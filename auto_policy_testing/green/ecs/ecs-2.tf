resource "aws_ecs_cluster" "this2" {
  name = "${module.naming.resource_prefix.ecs}-2"

  configuration {
    execute_command_configuration {
      kms_key_id = data.terraform_remote_state.common.outputs.kms_key_arn
      logging = "OVERRIDE"

      log_configuration {
        s3_bucket_name               = aws_s3_bucket.this.id
        s3_bucket_encryption_enabled = true
        s3_key_prefix                = "exec-output"
      }
    }
  }
}

resource "aws_ecs_service" "this2" {
  name                    = "${module.naming.resource_prefix.ecs_service}-2"
  cluster                 = aws_ecs_cluster.this2.id
  task_definition         = aws_ecs_task_definition.this2.arn
  enable_ecs_managed_tags = true
  enable_execute_command  = true
  desired_count           = 1
  launch_type             = "EC2"
  scheduling_strategy     = "REPLICA"

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }
  ordered_placement_strategy {
    type  = "spread"
    field = "host"
  }
  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }
  
  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id]
    assign_public_ip = false
  }

  depends_on = [ time_sleep.wait_60_seconds ]
}

resource "aws_ecs_task_definition" "this2" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-2"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task-execution-role.arn
  task_role_arn            = aws_iam_role.task-role.arn
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"
  runtime_platform {
    operating_system_family = "LINUX"
  }

  cpu    = 256
  memory = 512

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "httpd",
    "image": "httpd",
    "privileged": false,
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

  depends_on = [aws_cloudwatch_log_group.this,aws_s3_bucket.this,aws_security_group.this]
}

resource "time_sleep" "wait_60_seconds" {
  create_duration = "60s"
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = "${module.naming.resource_prefix.ecs}-2"
  capacity_providers = [aws_ecs_capacity_provider.this.name]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 1
    capacity_provider = aws_ecs_capacity_provider.this.name
  }
}

resource "aws_ecs_capacity_provider" "this" {
  name = "${module.naming.resource_prefix.ecs}-2"

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

resource "aws_ecs_task_definition" "this3" {
  family                   = "${module.naming.resource_prefix.ecs_task_definition}-2"
  network_mode             = "host"
  execution_role_arn       = aws_iam_role.task-execution-role.arn
  task_role_arn            = aws_iam_role.task-role.arn
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"

  cpu    = 256
  memory = 512

  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "httpd",
    "image": "httpd",
    "privileged": true,
    "entryPoint": ["sh", "-c"],
    "command": ["while true; do sleep 1000; done"],
    "linuxParameters": {
        "initProcessEnabled": true
    }
  }
]
TASK_DEFINITION
}