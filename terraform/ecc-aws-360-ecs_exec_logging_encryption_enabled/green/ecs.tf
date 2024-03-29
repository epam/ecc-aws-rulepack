resource "aws_ecs_cluster" "this" {
  name = "360_ecs_cluster_green"

  configuration {
    execute_command_configuration {
      kms_key_id = aws_kms_key.this.arn
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = true
        cloud_watch_log_group_name   = aws_cloudwatch_log_group.this.name
        s3_bucket_name               = aws_s3_bucket.this.id
        s3_bucket_encryption_enabled = true
        s3_key_prefix                = "exec-output"
      }
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "360-ecs-task-green"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task-execution-role.arn
  task_role_arn            = aws_iam_role.task-role.arn
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  container_definitions = <<TASK_DEFINITION
[
  {
          "name": "nginx",
            "image": "nginx",
            "linuxParameters": {
                "initProcessEnabled": true
            },            
            "logConfiguration": {
                "logDriver": "awslogs",
                    "options": {
                       "awslogs-group": "/aws/ecs/360_log_group_green",
                       "awslogs-region": "us-east-1",
                       "awslogs-stream-prefix": "container-stdout"
                    }
            }
  }
]
TASK_DEFINITION

  depends_on = [aws_cloudwatch_log_group.this,aws_s3_bucket.this,aws_iam_role.task-execution-role,aws_iam_role.task-role,aws_security_group.this]
}

resource "aws_ecs_service" "this" {
  name                    = "ecs-service"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.this.arn
  enable_ecs_managed_tags = true
  desired_count           = 1
  enable_execute_command  = true
  launch_type             = "FARGATE"
  platform_version        = "1.4.0"
  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.aws_subnets.this.ids[0]]
    assign_public_ip = true
  }
 
  depends_on = [aws_ecs_task_definition.this]
}