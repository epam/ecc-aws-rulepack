resource "aws_iam_role" "this" {
  name                 = "110_iam-role_green2"
  assume_role_policy   = <<EOF
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

resource "aws_iam_policy" "this" {
  name = "110_iam-policy_green2"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams"
      ],
      "Resource": "${aws_cloudwatch_log_group.this.arn}:*"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_role" "ecs_volume_role" {
  name                 = "110_iam-role-ecs_volume_green2"
  assume_role_policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowAccessToECSForInfrastructureManagement", 
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs.amazonaws.com" 
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "this3" {
  role       = aws_iam_role.ecs_volume_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSInfrastructureRolePolicyForVolumes"
}

data "aws_caller_identity" "this" {}