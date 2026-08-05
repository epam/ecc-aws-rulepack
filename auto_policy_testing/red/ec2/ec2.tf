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

  provider = aws.provider2
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  provider   = aws.provider2
}

resource "aws_iam_instance_profile" "this" {
  name     = module.naming.resource_prefix.ec2
  role     = aws_iam_role.this.name
  provider = aws.provider2
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "a1.medium"
  provider               = aws.provider2
  subnet_id              = aws_subnet.this.id
  tenancy                = "dedicated"
  iam_instance_profile   = aws_iam_instance_profile.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 5
  }

  # Required for ecc-aws-091 patch group targeting
  tags = {
    "Patch Group" = aws_ssm_patch_group.this.patch_group
  }

  depends_on = [
    aws_iam_role_policy_attachment.ssm,
    aws_internet_gateway.this,
    aws_route_table_association.this,
  ]
}

# Bare instance for policies that conflict with the SSM-managed one:
# - ecc-aws-020: no tags
# - ecc-aws-057: no IAM instance profile
# - ecc-aws-222: not managed by SSM
resource "aws_instance" "bare" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t4g.nano"
  provider               = aws.provider2
  subnet_id              = aws_subnet.this.id
  vpc_security_group_ids = [aws_security_group.this.id]

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "optional"
  }

  depends_on = [
    aws_internet_gateway.this,
    aws_route_table_association.this,
  ]
}

resource "aws_ebs_volume" "this" {
  size              = 1
  availability_zone = local.availability_zone
  provider          = aws.provider2
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
  provider    = aws.provider2
}

resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  provider             = aws.provider2
}

# Public subnet so the instance gets a public IP (ecc-aws-186) and can reach SSM
resource "aws_subnet" "this" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = local.availability_zone
  map_public_ip_on_launch = true
  provider                = aws.provider2
}

resource "aws_internet_gateway" "this" {
  vpc_id   = aws_vpc.this.id
  provider = aws.provider2
}

resource "aws_route_table" "this" {
  vpc_id   = aws_vpc.this.id
  provider = aws.provider2

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "this" {
  subnet_id      = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
  provider       = aws.provider2
}

resource "aws_security_group" "this" {
  name     = module.naming.resource_prefix.ec2
  vpc_id   = aws_vpc.this.id
  provider = aws.provider2

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_network_interface" "this" {
  subnet_id       = aws_subnet.this.id
  private_ips     = ["10.0.1.49"]
  security_groups = [aws_security_group.this.id]
  provider        = aws.provider2

  attachment {
    instance     = aws_instance.this.id
    device_index = 1
  }
}

resource "aws_ssm_patch_baseline" "this" {
  name                                 = module.naming.resource_prefix.ec2
  description                          = "Patch Baseline Description 091 red"
  operating_system                     = "AMAZON_LINUX_2"
  approved_patches_enable_non_security = true
  rejected_patches                     = ["amazon-ssm-agent"]
  rejected_patches_action              = "BLOCK"
  provider                             = aws.provider2

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
  patch_group = "Patch_Group_091_red"
  provider    = aws.provider2
}

resource "aws_ssm_maintenance_window" "this" {
  name     = module.naming.resource_prefix.ec2
  schedule = "rate(5 minutes)"
  duration = 3
  cutoff   = 1
  provider = aws.provider2
}

resource "aws_ssm_maintenance_window_target" "this" {
  window_id     = aws_ssm_maintenance_window.this.id
  name          = module.naming.resource_prefix.ec2
  resource_type = "INSTANCE"
  provider      = aws.provider2

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
  provider         = aws.provider2

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
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}

# Intentionally failing association for ecc-aws-223 (NON_COMPLIANT)
resource "aws_ssm_association" "this" {
  name                = "AWS-RunShellScript"
  association_name    = module.naming.resource_prefix.ec2
  compliance_severity = "CRITICAL"
  schedule_expression = "rate(30 minutes)"
  provider            = aws.provider2

  parameters = {
    commands = "exit 1"
  }

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  depends_on = [aws_instance.this]
}

# Wait for SSM registration, association/patch compliance reporting (091, 223)
resource "time_sleep" "wait_ssm_compliance" {
  depends_on = [
    aws_instance.this,
    aws_ssm_association.this,
    aws_ssm_maintenance_window_task.this,
    aws_ssm_maintenance_window_target.this,
  ]

  create_duration = "12m"
}
