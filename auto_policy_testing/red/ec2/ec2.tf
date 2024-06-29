resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "a1.medium"
  provider      = aws.provider2
  subnet_id     = aws_subnet.this.id
  tenancy       = "dedicated"

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 5 
  }
}

resource "aws_ebs_volume" "this" {
  size              = 1
  availability_zone = data.aws_availability_zones.this.names[0]
}

resource "aws_volume_attachment" "this" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this.id
  instance_id = aws_instance.this.id
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_network_interface" "this" {
  subnet_id   = aws_subnet.this.id
  private_ips = ["10.0.1.49"]

  attachment {
    instance     = aws_instance.this.id
    device_index = 1
  }
}

resource "aws_ssm_patch_baseline" "this" {
  name                                 = "${module.naming.resource_prefix.ec2}"
  description                          = "Patch Baseline Description 091 red"
  operating_system                     = "AMAZON_LINUX_2"
  approved_patches_enable_non_security = true
  rejected_patches                     = ["amazon-ssm-agent"]
  rejected_patches_action              = "BLOCK"

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
}

resource "aws_ssm_maintenance_window" "this" {
  name     = "${module.naming.resource_prefix.ec2}"
  schedule = "rate(5 minutes)"
  duration = 3
  cutoff   = 1
}

resource "aws_ssm_maintenance_window_target" "this" {
  window_id     = aws_ssm_maintenance_window.this.id
  name          = "${module.naming.resource_prefix.ec2}"
  resource_type = "INSTANCE"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }
}

resource "aws_ssm_maintenance_window_task" "this" {
  name             = "${module.naming.resource_prefix.ec2}"
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
      parameter {
        name   = "RebootOption"
        values = ["NoReboot"]
      }
    }
  }
}

resource "aws_ssm_association" "this" {
  name                = "AWS-UpdateSSMAgent"
  association_name    = "${module.naming.resource_prefix.ec2}"
  compliance_severity = "MEDIUM"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  depends_on = [aws_instance.this]
}