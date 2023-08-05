resource "aws_ecs_cluster" "this" {
  name = "ecc-aws-537-ecs_task_definitions_green"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "537_ecs_task_definition_green"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "privileged": false,
    "user": "test" 
  }
]
DEFINITION
}
