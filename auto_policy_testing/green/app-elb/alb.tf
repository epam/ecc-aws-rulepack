resource "aws_lb" "this" {
  # "${module.naming.resource_prefix.kafka}"
  name                       = "alb-111-green"
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.this.id]
  subnets                    = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  internal                   = false
  drop_invalid_header_fields = true
  # enable_deletion_protection = true
  desync_mitigation_mode     = "defensive"

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }

  depends_on = [
    aws_s3_bucket_acl.this
  ]
}

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.this.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }

  }
}

resource "aws_security_group_rule" "rule1" {
    type        = "ingress"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
    security_group_id = aws_security_group.this.id
  }

resource "aws_security_group_rule" "rule2" {
  type        = "egress"
  from_port   = 443
  to_port     = 443
  protocol    = "tcp"
  cidr_blocks = [aws_vpc.this.cidr_block]
  security_group_id = aws_security_group.this.id
}

resource "aws_wafregional_ipset" "this" {
  name = "GreenWAFRegionalIPSet"
}

resource "aws_wafregional_rule" "this" {
  name        = "GreenWAFRegionalRule"
  metric_name = "GreenWAFRegionalRule"

  predicate {
    data_id = aws_wafregional_ipset.this.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_web_acl" "this" {
  name        = "GreenWAFRegionalACL"
  metric_name = "GreenWAFRegionalACL"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_wafregional_rule.this.id
  }
}

resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_lb.this.arn
  web_acl_id   = aws_wafregional_web_acl.this.id
}

# resource "aws_vpc" "this" {
#   cidr_block       = "10.0.0.0/16"
#   instance_tenancy = "default"
# }

# resource "aws_subnet" "subnet1" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = data.aws_availability_zones.this.names[0]
# }

# resource "aws_subnet" "subnet2" {
#   vpc_id            = aws_vpc.this.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = data.aws_availability_zones.this.names[1]
# }

resource "aws_vpc" "this" {
  cidr_block       = "172.17.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "subnet1" {
  availability_zone = data.aws_availability_zones.this.names[0]
  cidr_block        = "172.17.0.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_subnet" "subnet2" {
  availability_zone = data.aws_availability_zones.this.names[1]
  cidr_block        = "172.17.1.0/24"
  vpc_id            = aws_vpc.this.id
}

resource "aws_security_group" "this" {
  name        = "allow_http"
  description = "Allow HTTP inbound traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}


resource "aws_s3_bucket" "this" {
  bucket        = "129-bucket-${random_integer.this.result}-green"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 10000
  max = 99999
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}
