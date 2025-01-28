resource "aws_ecs_cluster" "this" {
  name = local.cluster_name
  configuration {
    managed_storage_configuration {
      kms_key_id                           = data.aws_kms_key.this_default.id
      fargate_ephemeral_storage_kms_key_id = aws_kms_key.this.id
    }
  }
}

data "aws_kms_key" "this_default" {
  key_id = "alias/aws/ebs"
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/110_ecs-logs_green2"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "110_task_green2"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  volume {
    name                = local.volume_name
    configure_at_launch = true
  }
  ephemeral_storage {
    size_in_gib = 21
  }
  cpu                = 256
  memory             = 512
  task_role_arn      = aws_iam_role.this.arn
  execution_role_arn = aws_iam_role.this.arn

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
                    "awslogs-group": "/ecs/110_ecs-logs_green2",
                    "awslogs-region": "${var.default-region}",
                    "awslogs-stream-prefix": "ecs"
                }
            }
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name                    = "110_ecs-service_green2"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.this.arn
  enable_ecs_managed_tags = true
  enable_execute_command  = true
  desired_count           = 1
  launch_type             = "FARGATE"
  platform_version        = "LATEST"
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
  network_configuration {
    security_groups  = [data.aws_security_group.this.id]
    subnets          = data.aws_subnets.this.ids
    assign_public_ip = true
  }
  depends_on = [aws_iam_role_policy_attachment.this1, aws_iam_role_policy_attachment.this2, aws_iam_role_policy_attachment.this3]
}
