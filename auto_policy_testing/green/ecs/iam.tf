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

#---

resource "aws_iam_role" "task-role" {
  name = "${module.naming.resource_prefix.ecs}-task-role"

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
  policy = templatefile("ecs-exec-task-role-policy.json", {
    bucket_arn = aws_s3_bucket.this.arn, 
    account_id = data.aws_caller_identity.this.account_id,
    kms_key_arn = data.terraform_remote_state.common.outputs.kms_key_arn, 
    cw_log_group = aws_cloudwatch_log_group.this.arn
    }
  )
}

resource "aws_iam_role_policy_attachment" "task-role1" {
  policy_arn = aws_iam_policy.task-role.arn
  role       = aws_iam_role.task-role.name
}

resource "aws_iam_role_policy_attachment" "task-role2" {
  role       = aws_iam_role.task-role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

#---

resource "aws_iam_role" "ecs-agent" {
  name                 = "${module.naming.resource_prefix.ecs}-ecs-agent"
  assume_role_policy   = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-agent1" {
  role       = aws_iam_role.ecs-agent.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "ecs-agent2" {
  role       = aws_iam_role.ecs-agent.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-agent" {
  name = "${module.naming.resource_prefix.ecs}-ecs-agent"
  role = aws_iam_role.ecs-agent.name
}
