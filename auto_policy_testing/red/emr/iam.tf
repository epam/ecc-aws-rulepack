resource "aws_iam_role" "emr_service_role" {
  name               = "${module.naming.resource_prefix.iam_role}-service"
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["elasticmapreduce.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "emr_service_role" {
  role       = aws_iam_role.emr_service_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEMRServicePolicy_v2"
}

resource "aws_iam_role_policy" "emr_service_role" {
  name = "${module.naming.resource_prefix.iam_policy}-service"
  role = aws_iam_role.emr_service_role.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:ReEncrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Sid = "CreateInNetwork"
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:RunInstances",
          "ec2:CreateFleet",
          "ec2:CreateLaunchTemplate",
          "ec2:CreateLaunchTemplateVersion",
          "ec2:AuthorizeSecurityGroupEgress",
          "ec2:AuthorizeSecurityGroupIngress",
          "ec2:RevokeSecurityGroupEgress",
          "ec2:RevokeSecurityGroupIngress"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:ec2:*:*:subnet/${data.terraform_remote_state.common.outputs.vpc_subnet_1_id}",
          "arn:aws:ec2:*:*:security-group/${aws_security_group.this.id}",
           "arn:aws:ec2:*:*:security-group/${aws_security_group.this.id}"
          ]
      },
      {
        Sid = "CreateDefaultSecurityGroupInVPC"
        Action = [
          "ec2:CreateSecurityGroup"
        ]
        Effect   = "Allow"
        Resource = ["arn:aws:ec2:*:*:vpc/${data.terraform_remote_state.common.outputs.vpc_id}"]
      },
      {
        Sid = "PassRoleForEC2"
        Action = [
          "iam:PassRole"
        ]
        Effect   = "Allow"
        Resource = [aws_iam_role.emr_ec2_instance_profile.arn]
      },
    ]
  })
}

resource "aws_iam_role" "emr_ec2_instance_profile" {
  name = "${module.naming.resource_prefix.iam_role}-profile"

  assume_role_policy = <<EOF
{
  "Version": "2008-10-17",
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

resource "aws_iam_role_policy" "emr_ec2_instance_profile" {
  name = "${module.naming.resource_prefix.iam_policy}-profile"
  role = aws_iam_role.emr_ec2_instance_profile.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "cloudwatch:*",
          "ec2:Describe*",
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_instance_profile" "this" {
  name = "${module.naming.resource_prefix.iam_role}-profile"
  role = aws_iam_role.emr_ec2_instance_profile.name
}

resource "aws_iam_role_policy_attachment" "iam_policy_green" {
  role       = aws_iam_role.emr_ec2_instance_profile.name
  policy_arn = aws_iam_policy.this.arn
}

resource "aws_iam_policy" "this" {
  name        = "${module.naming.resource_prefix.iam_policy}"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey",
          "kms:ReEncrypt",
          "kms:DescribeKey"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}