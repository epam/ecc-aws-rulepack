resource "aws_iam_role" "this" {
  name                 = module.naming.resource_prefix.ec2
  permissions_boundary = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:policy/eo_role_boundary"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = module.naming.resource_prefix.ec2
  role = aws_iam_role.this.name
}

resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = "t2.micro"
  monitoring           = true
  iam_instance_profile = aws_iam_instance_profile.this.name

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  ebs_block_device {
    delete_on_termination = true
    device_name           = "/dev/sdh"
    volume_size           = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm,
    aws_vpc_endpoint.ssm,
    aws_vpc_endpoint.ssmmessages,
    aws_vpc_endpoint.ec2messages,
  ]
}

resource "aws_ssm_patch_baseline" "this" {
  name                                 = module.naming.resource_prefix.ec2
  description                          = "Patch Baseline Description 091"
  operating_system                     = "AMAZON_LINUX_2"
  approved_patches_enable_non_security = true

  global_filter {
    key    = "PRODUCT"
    values = ["*"]
  }

  global_filter {
    key    = "CLASSIFICATION"
    values = ["*"]
  }

  global_filter {
    key    = "SEVERITY"
    values = ["*"]
  }

  approval_rule {
    approve_after_days  = 0
    enable_non_security = true

    patch_filter {
      key    = "PRODUCT"
      values = ["*"]
    }

    patch_filter {
      key    = "CLASSIFICATION"
      values = ["*"]
    }

    patch_filter {
      key    = "SEVERITY"
      values = ["*"]
    }
  }
}

resource "aws_ssm_patch_group" "this" {
  baseline_id = aws_ssm_patch_baseline.this.id
  patch_group = module.naming.resource_prefix.ec2
}

resource "aws_ssm_maintenance_window" "this" {
  name     = module.naming.resource_prefix.ec2
  schedule = "rate(5 minutes)"
  duration = 3
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "this" {
  window_id     = aws_ssm_maintenance_window.this.id
  name          = module.naming.resource_prefix.ec2
  resource_type = "INSTANCE"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }
}

resource "aws_ssm_maintenance_window_task" "this" {
  name             = module.naming.resource_prefix.ec2
  max_concurrency  = 2
  max_errors       = 1
  priority         = 1
  task_arn         = "AWS-RunPatchBaseline"
  task_type        = "RUN_COMMAND"
  window_id        = aws_ssm_maintenance_window.this.id
  service_role_arn = data.aws_iam_role.ssm.arn

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  task_invocation_parameters {
    run_command_parameters {
      parameter {
        name   = "Operation"
        values = ["Install"]
      }
    }
  }
}

resource "aws_ssm_association" "this" {
  name                = "AWS-UpdateSSMAgent"
  association_name    = module.naming.resource_prefix.ec2
  compliance_severity = "MEDIUM"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  depends_on = [aws_instance.this]
}

resource "aws_network_interface" "this" {
  subnet_id       = aws_subnet.this.id
  security_groups = [aws_security_group.this.id]
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}

resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = false
}

resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.ec2
  vpc_id = aws_vpc.this.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  ingress {
    description = "HTTPS from VPC for SSM endpoints"
    from_port   = 443
    to_port     = 443
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

# Private SSM connectivity without assigning a public IP (ecc-aws-186 + ecc-aws-222)
resource "aws_vpc_endpoint" "ssm" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssm"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.this.id]
  security_group_ids  = [aws_security_group.this.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ssmmessages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ssmmessages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.this.id]
  security_group_ids  = [aws_security_group.this.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ec2messages" {
  vpc_id              = aws_vpc.this.id
  service_name        = "com.amazonaws.${var.region}.ec2messages"
  vpc_endpoint_type   = "Interface"
  subnet_ids          = [aws_subnet.this.id]
  security_group_ids  = [aws_security_group.this.id]
  private_dns_enabled = true
}

# Allow SSM agent time to register the instance
resource "time_sleep" "wait_ssm" {
  depends_on = [
    aws_instance.this,
    aws_ssm_association.this,
  ]

  create_duration = "3m"
}
