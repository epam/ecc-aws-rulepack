resource "aws_ecs_cluster" "this1" {
  provider               = aws.provider2
  name = "${module.naming.resource_prefix.ecs}-1"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name   = aws_cloudwatch_log_group.this.name
        s3_bucket_name               = aws_s3_bucket.this.id
      }
    }
  }
}

resource "aws_ecs_service" "this1" {
  name             = "${module.naming.resource_prefix.ecs_service}-1"
  cluster          = aws_ecs_cluster.this1.id
  task_definition  = aws_ecs_task_definition.this1.arn
  desired_count    = 1
  launch_type             = "FARGATE"
  platform_version        = "1.4.0"

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
    assign_public_ip = true
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
      }
  }
]
TASK_DEFINITION
}


resource "aws_ecs_service" "this5" {
  name             = "${module.naming.resource_prefix.ecs_service}-5"
  cluster          = aws_ecs_cluster.this1.id
  task_definition  = aws_ecs_task_definition.this5.arn
  desired_count    = 1
  launch_type      = "FARGATE"
  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]
    assign_public_ip = false
  }
}

resource "aws_ecs_task_definition" "this5" {
    family                   = "${module.naming.resource_prefix.ecs_task_definition}-5"
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"
    cpu    = 256
    memory = 512

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "httpd",
      "image": "httpd",
      "entryPoint": ["sh", "-c"],
      "command": ["while true; do sleep 1000; done"],
      "linuxParameters": {
          "initProcessEnabled": true
      }
  }
]
TASK_DEFINITION
}