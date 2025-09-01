# doc: https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/iam-servicerole.html#iam-servicerole-console

resource "aws_iam_instance_profile" "this" {
  name = "292_profile_green"
  role = aws_iam_role.this1.name
}

resource "aws_iam_role" "this1" {
  name               = "292_role_green"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "ec2.amazonaws.com"},
    "Action": "sts:AssumeRole"
     }
}
EOF
}

resource "aws_iam_role_policy_attachment" "this1" {
  role       = aws_iam_role.this1.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "this2" {
  role       = aws_iam_role.this1.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkWebTier"
}


resource "aws_iam_role" "this2" {
  name               = "292_service_role_green"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": {
    "Effect": "Allow",
    "Principal": {"Service": "elasticbeanstalk.amazonaws.com"},
    "Action": "sts:AssumeRole",
     "Condition": {
          "StringEquals": {
            "sts:ExternalId": "elasticbeanstalk"
          }
        }
    }
}
EOF
}

resource "aws_iam_role_policy_attachment" "this3" {
  role       = aws_iam_role.this2.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSElasticBeanstalkEnhancedHealth"
}

resource "aws_iam_role_policy_attachment" "this4" {
  role       = aws_iam_role.this2.name
  policy_arn = "arn:aws:iam::aws:policy/AWSElasticBeanstalkManagedUpdatesCustomerRolePolicy"
}