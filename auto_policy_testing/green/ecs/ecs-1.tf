resource "aws_ecs_cluster" "this1" {
  name = "${module.naming.resource_prefix.ecs}-1"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      kms_key_id = data.terraform_remote_state.common.outputs.kms_key_arn
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name   = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "this1" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-1"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task-execution-role.arn
  task_role_arn            = aws_iam_role.task-role.arn
  requires_compatibilities = ["FARGATE", "EC2"]

  cpu    = 256
  memory = 512

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "httpd",
    "image": "httpd",
    "entryPoint": ["sh", "-c"],
    "cpu": 1,
    "memory": 5,
    "ReadonlyRootFilesystem": true,
    "command": ["while true; do sleep 1000; done"],
    "linuxParameters": {
        "initProcessEnabled": true
    },            
    "logConfiguration": {
        "logDriver": "awslogs",
            "options": {
                "awslogs-group": "${aws_cloudwatch_log_group.this.name}",
                "awslogs-region": "${var.region}",
                "awslogs-stream-prefix": "container-stdout"
            }
    },
    "environment": [
      {
        "name": "AWS_ACCESS_KEY_ID",
        "value": "arn:qwe:test_path_to_ssm_parameter"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY", 
        "value": "arn:qwe:test_path_to_secrets_manager_secret"
      },
      {
        "name": "ECS_ENGINE_AUTH_DATA", 
        "value": "arn:qwe:test"
      }
    ]
  }
]
TASK_DEFINITION

  depends_on = [aws_cloudwatch_log_group.this,aws_s3_bucket.this,aws_iam_role.task-execution-role,aws_iam_role.task-role,aws_security_group.this]
}

resource "aws_ecs_service" "this1" {
  name                    = "${module.naming.resource_prefix.ecs_service}-1"
  cluster                 = aws_ecs_cluster.this1.id
  task_definition         = aws_ecs_task_definition.this1.arn
  enable_ecs_managed_tags = true
  desired_count           = 1
  enable_execute_command  = true
  launch_type             = "FARGATE"
  platform_version        = "LATEST"

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id]
    assign_public_ip = false
  }
}



resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  ingress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${module.naming.resource_prefix.security_group}"
  }
}