resource "aws_ecs_cluster" "this" {
  name = "ecc-aws-537-ecs_task_definitions_red"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "537_ecs_task_definition_red"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
    "essential": true,
    "privileged": true,
    "user": "test" 
  }
]
DEFINITION
}
