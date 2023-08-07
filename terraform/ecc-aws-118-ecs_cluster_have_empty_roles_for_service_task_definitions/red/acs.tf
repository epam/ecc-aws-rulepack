resource "aws_ecs_cluster" "this" {
  name = "118_ecs_cluster_red"
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
    family                = "service"
    container_definitions = <<DEFINITION
[
  {
    "name": "mysql",
    "image": "mysql",
    "cpu": 2,
    "memory": 10,
    "essential": true
  }
]
DEFINITION
}

resource "aws_ecs_service" "this" {
  	name            = "118_ecs_service_red"
  	cluster         = aws_ecs_cluster.this.id
  	task_definition = "${aws_ecs_task_definition.this.family}:${max("${aws_ecs_task_definition.this.revision}", "${data.aws_ecs_task_definition.this.revision}")}"
  	desired_count   = 2
}