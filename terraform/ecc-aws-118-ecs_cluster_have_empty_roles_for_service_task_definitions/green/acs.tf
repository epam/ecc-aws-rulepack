resource "aws_ecs_cluster" "this" {
  name = "118_ecs_cluster_green"
}

data "aws_ecs_task_definition" "this" {
  task_definition = aws_ecs_task_definition.this.family
  depends_on = [aws_ecs_task_definition.this]
}

resource "aws_ecs_task_definition" "this" {
    family                = "service"
    task_role_arn         = aws_iam_role.this.arn
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

resource "aws_iam_role" "this" {
  name = "118_role_green"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
            "Service": [
                "s3.amazonaws.com"
            ]
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

resource "aws_ecs_service" "this" {
  	name            = "118_ecs_service_green"
  	cluster         = aws_ecs_cluster.this.id
  	task_definition = "${aws_ecs_task_definition.this.family}:${max("${aws_ecs_task_definition.this.revision}", "${data.aws_ecs_task_definition.this.revision}")}"
  	desired_count   = 2
}