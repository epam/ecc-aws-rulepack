resource "aws_ecs_cluster" "this" {
  name = "${module.naming.resource_prefix.ecs}"

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
        s3_bucket_name               = aws_s3_bucket.this.id
        s3_bucket_encryption_enabled = true
        s3_key_prefix                = "exec-output"
      }
    }
  }
}

resource "aws_ecs_task_definition" "this" {
  family                   = "${module.naming.resource_prefix.ecs}"
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
                       "awslogs-group": "/aws/ecs/${module.naming.resource_prefix.ecs}",
                       "awslogs-region": "us-east-1",
                       "awslogs-stream-prefix": "container-stdout"
                    }
            }
  }
]
TASK_DEFINITION

  depends_on = [aws_cloudwatch_log_group.this,aws_s3_bucket.this,aws_iam_role.task-execution-role,aws_iam_role.task-role,aws_security_group.this]
}

# ecc-aws-521-ecs_containers_readonly_access
# ecc-aws-495-ecs_task_definition_memory_hard_limit
resource "aws_ecs_task_definition" "this2" {
  family                   = "${module.naming.resource_prefix.ecs}"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  pid_mode                 = "task"
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "ReadonlyRootFilesystem": true
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  name                    = "${module.naming.resource_prefix.ecs_service}"
  cluster                 = aws_ecs_cluster.this.id
  task_definition         = aws_ecs_task_definition.this.arn
  enable_ecs_managed_tags = true
  desired_count           = 1
  enable_execute_command  = true
  launch_type             = "FARGATE"
  platform_version        = "LATEST"

  network_configuration {
    security_groups  = [aws_security_group.this.id]
    subnets          = [data.aws_subnets.this.ids[0]]
    assign_public_ip = false
  }
 
  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_iam_role" "task-execution-role" {
  name = "${module.naming.resource_prefix.ecs}-execution"

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

resource "aws_iam_role_policy_attachment" "task-execution-role" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.task-execution-role.name
}

resource "aws_iam_role" "task-role" {
  name = "${module.naming.resource_prefix.ecs}"

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

resource "aws_iam_policy" "task-role" {
  name        = "${module.naming.resource_prefix.ecs}"
  policy = templatefile("ecs-exec-task-role-policy.json", {bucket_arn = aws_s3_bucket.this.arn, account_id = data.aws_caller_identity.this.account_id,kms_key_arn = data.terraform_remote_state.common.outputs.kms_key_arn})
}

resource "aws_iam_role_policy_attachment" "task-role" {
  policy_arn = aws_iam_policy.task-role.arn
  role       = aws_iam_role.task-role.name
}

resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/ecs/${module.naming.resource_prefix.ecs}"
  retention_in_days = 7
  kms_key_id = data.terraform_remote_state.common.outputs.kms_key_arn
}

resource "aws_s3_bucket" "this" {
  bucket        = "${module.naming.resource_prefix.ecs}-${random_integer.this.result}"
  force_destroy = true
}

resource "random_integer" "this" {
  min = 1
  max = 10000000
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "this" {
  depends_on = [aws_s3_bucket_ownership_controls.this]

  bucket = aws_s3_bucket.this.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

data "aws_vpc" "default" {
  default = true
} 

data "aws_subnets" "this" {
  filter {
    name   = "availability-zone"
    values = ["us-east-1a"]
  }
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.ecs}"
  vpc_id = data.aws_vpc.default.id

  ingress {
    description = "SSH from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

    ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["46.119.180.191/32"]
  }

  ingress {
    description = "HTTP from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}