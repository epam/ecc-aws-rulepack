resource "aws_ecs_cluster" "this" {
  name = "907-ecs-cluster-red"
}

resource "aws_ecs_task_definition" "this" {
  family                   = "907_ecs_task_definition_red"
  network_mode             = "host"
  requires_compatibilities = ["EC2"]
  container_definitions    = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 1,
    "memory": 5,
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

resource "aws_ecs_service" "this" {
  name            = "907_ecs_service_red"
  cluster         = aws_ecs_cluster.this.id
  task_definition = aws_ecs_task_definition.this.arn
  desired_count   = 1
}
