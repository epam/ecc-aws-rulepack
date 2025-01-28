resource "aws_iam_role" "this1" {
  name               = "118_iam_task_exec_role_red"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
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


resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this1.name
  policy_arn = aws_iam_policy.this.arn
}