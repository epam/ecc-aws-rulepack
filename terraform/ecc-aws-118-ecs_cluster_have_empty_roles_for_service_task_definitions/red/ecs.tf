resource "aws_ecs_task_definition" "this" {
  family                   = "118_task_red"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
  cpu                   = 256
  memory                = 512
  container_definitions = <<DEFINITION
[
  {
    "name": "sample-app",
    "image":  "public.ecr.aws/docker/library/nginx:latest"
  }
]
DEFINITION
}
