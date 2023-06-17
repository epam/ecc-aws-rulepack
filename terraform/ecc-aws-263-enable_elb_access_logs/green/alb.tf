resource "aws_lb" "this" {
  name               = "lb-263-green"
  security_groups    = [aws_security_group.this.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
  load_balancer_type = "application"

  access_logs {
    bucket  = aws_s3_bucket.this.bucket
    enabled = true
  }
}

resource "aws_s3_bucket" "this" {
  bucket        = "bucket-263-green"
  force_destroy = true
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
}
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::bucket-263-green/AWSLogs/*"]
  }
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name   = "263_security_group_green"
  vpc_id = aws_vpc.this.id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rule1" {
  type      = "ingress"
  from_port = 22
  to_port   = 22
  protocol  = "tcp"
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
}
resource "aws_security_group_rule" "rule2" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.this.id
  to_port           = 80
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  type = "ingress"
}

resource "aws_security_group_rule" "rule3" {
  protocol  = "tcp"
  from_port = 443
  to_port   = 443
  cidr_blocks = [
    "0.0.0.0/0"
  ]
  security_group_id = aws_security_group.this.id
  type              = "ingress"
}
resource "aws_security_group_rule" "rule4" {
  security_group_id = aws_security_group.this.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks = [
  "0.0.0.0/0"]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}