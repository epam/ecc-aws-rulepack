resource "aws_ecs_cluster" "this" {
  name = local.cluster_name
  configuration {
    managed_storage_configuration {
      kms_key_id = data.aws_kms_key.this.id
    }
  }
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/ebs"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/110_ecs-logs_green1"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "110_task_green1"
  requires_compatibilities = ["EC2"]
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  volume {
    name                = local.volume_name
    configure_at_launch = true
  }
  cpu                = 128
  memory             = 256
  execution_role_arn = aws_iam_role.this.arn
  task_role_arn      = aws_iam_role.this.arn

  container_definitions = <<DEFINITION
[
  {
    "name": "sample-app",
    "image":  "public.ecr.aws/docker/library/nginx:latest",
    "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80,
          "protocol": "tcp"
        }
    ],
    "mountPoints": [
      {
        "sourceVolume": "${local.volume_name}",
        "containerPath": "/foo"
      }
    ],
    "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/110_ecs-logs_green1",
                    "awslogs-region": "${var.default-region}",
                    "awslogs-stream-prefix": "ecs"
                }
            }
  }
]
DEFINITION
}
resource "aws_ecs_service" "this" {
  name                    = "110_ecs-service_green1"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.this.arn
  enable_ecs_managed_tags = true
  enable_execute_command  = true
  desired_count           = 1
  launch_type             = "EC2"
  scheduling_strategy     = "REPLICA"
  force_delete            = true
  volume_configuration {
    name = local.volume_name
    managed_ebs_volume {
      role_arn         = aws_iam_role.ecs_volume_role.arn
      encrypted        = true
      volume_type      = "gp3"
      size_in_gb       = 1
      file_system_type = "ext4"
      tag_specifications {
        resource_type  = "volume"
        propagate_tags = "TASK_DEFINITION"
      }
    }
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  depends_on = [aws_iam_role_policy_attachment.this1, aws_iam_role_policy_attachment.this2, aws_iam_role_policy_attachment.this3, aws_iam_role_policy_attachment.this4, aws_iam_role_policy_attachment.this5, time_sleep.wait_60_seconds, aws_ecs_cluster_capacity_providers.this, aws_ecs_capacity_provider.this, aws_autoscaling_group.this]
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
  depends_on      = [aws_autoscaling_group.this]
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = "110_capacity-provider_green1"
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.this.arn
    managed_termination_protection = "DISABLED"
    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
      instance_warmup_period    = 300
    }
  }
}