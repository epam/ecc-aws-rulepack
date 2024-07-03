
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
    values = [aws_instance.this2.id]
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
    values = [aws_instance.this2.id]
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
  name                = "AWS-ConfigureAWSPackage"
  association_name    = "${module.naming.resource_prefix.ec2}"
  compliance_severity = "MEDIUM"
  schedule_expression = "rate(30 minutes)"

  parameters = {
    action = "Install"
    installationType = "In-place update"
    name = "AmazonCloudWatchAgent"
  }

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this2.id]
  }

  depends_on = [aws_instance.this2]
}