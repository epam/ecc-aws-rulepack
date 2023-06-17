data "aws_caller_identity" "this" {}

resource "aws_iam_role" "task-execution-role" {
  name = "525_ecs-exec-task-execution-role_green"

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
  name = "525_ecs-exec-task-role_green"

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
  name        = "525_ecs-exec-task-policy_green"
  policy = templatefile("ecs-exec-task-role-policy.json", {bucket_arn = aws_s3_bucket.this.arn, account_id = data.aws_caller_identity.this.account_id,kms_key_arn = aws_kms_key.this.arn})
}

resource "aws_iam_role_policy_attachment" "task-role" {
  policy_arn = aws_iam_policy.task-role.arn
  role       = aws_iam_role.task-role.name
}