# Untagged cluster (403) with exec logging encryption disabled (360)
resource "aws_ecs_cluster" "this" {
  provider = aws.provider2
  name     = module.naming.resource_prefix.ecs

  setting {
    name  = "containerInsights"
    value = "disabled"
  }

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.this.name
        cloud_watch_encryption_enabled = false
      }
    }
  }
}

# Exec command logging fully disabled (464)
resource "aws_ecs_cluster" "no_exec_logging" {
  name = "${module.naming.resource_prefix.ecs}-no-exec-logging"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${module.naming.resource_prefix.ecs}"
  retention_in_days = 7
}

resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.ecs
  vpc_id = data.aws_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Fargate task used by the public-IP service (165)
resource "aws_ecs_task_definition" "fargate" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-fargate"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution.arn
  task_role_arn            = aws_iam_role.task.arn
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  container_definitions = <<DEFINITION
[
  {
    "name": "nginx",
    "image": "nginx",
    "essential": true,
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
DEFINITION
}

# Public IP assigned automatically (165) + non-LATEST Fargate platform (494)
resource "aws_ecs_service" "this" {
  name                   = module.naming.resource_prefix.ecs_service
  cluster                = aws_ecs_cluster.this.id
  task_definition        = aws_ecs_task_definition.fargate.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  platform_version       = "1.4.0"
  enable_execute_command = true

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.aws_subnets.this.ids[0]]
    assign_public_ip = true
  }

  depends_on = [aws_ecs_task_definition.fargate]
}

# Placement strategy random (582); desired_count=0 so no EC2 capacity is required
resource "aws_ecs_service" "placement" {
  name                = "${module.naming.resource_prefix.ecs_service}-placement"
  cluster             = aws_ecs_cluster.no_exec_logging.id
  task_definition     = aws_ecs_task_definition.pid_host_secrets.arn
  desired_count       = 0
  launch_type         = "EC2"
  scheduling_strategy = "REPLICA"

  ordered_placement_strategy {
    type = "random"
  }

  depends_on = [aws_ecs_task_definition.pid_host_secrets]
}

# No container memory hard limit (495) — memoryReservation only
resource "aws_ecs_task_definition" "no_memory_limit" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-no-mem"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"

  container_definitions = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memoryReservation": 5,
    "essential": true
  }
]
DEFINITION
}

# pidMode=host (496) + secrets in environment (522)
resource "aws_ecs_task_definition" "pid_host_secrets" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-pid-host"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "host"

  container_definitions = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "environment": [
      {
        "name": "AWS_ACCESS_KEY_ID",
        "value": "arn:qwe:test"
      },
      {
        "name": "AWS_SECRET_ACCESS_KEY",
        "value": "test"
      },
      {
        "name": "ECS_ENGINE_AUTH_DATA",
        "value": "test"
      }
    ]
  }
]
DEFINITION
}

# Privileged container on non-host network (537)
resource "aws_ecs_task_definition" "privileged" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-privileged"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]

  container_definitions = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "privileged": true
  }
]
DEFINITION
}

resource "aws_iam_role" "task_execution" {
  name                 = "${module.naming.resource_prefix.ecs}-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "task_execution" {
  role       = aws_iam_role.task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "task" {
  name                 = "${module.naming.resource_prefix.ecs}-task"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ecs-tasks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "task" {
  name = module.naming.resource_prefix.ecs
  policy = templatefile("${path.module}/ecs-exec-task-role-policy.json", {
    cw_log_group = aws_cloudwatch_log_group.this.arn
  })
}

resource "aws_iam_role_policy_attachment" "task" {
  role       = aws_iam_role.task.name
  policy_arn = aws_iam_policy.task.arn
}
