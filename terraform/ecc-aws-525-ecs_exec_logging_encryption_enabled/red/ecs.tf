resource "aws_ecs_cluster" "this" {
  name = "525_ecs_cluster_red"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name   = aws_cloudwatch_log_group.this.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "525-ecs-task-red"
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
                       "awslogs-group": "/aws/ecs/525_log_group_red",
                       "awslogs-region": "us-east-1",
                       "awslogs-stream-prefix": "container-stdout"
                    }
            }
  }
]
TASK_DEFINITION

  depends_on = [aws_cloudwatch_log_group.this,aws_iam_role.task-execution-role,aws_iam_role.task-role,aws_security_group.this]
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