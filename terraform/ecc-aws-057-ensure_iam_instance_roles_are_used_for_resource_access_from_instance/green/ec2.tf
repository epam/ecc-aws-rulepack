resource "aws_iam_role" "this" {
  name = "057_role_green"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "this" {
  name = "057_instance_profile_green"
  role = aws_iam_role.this.name
}

resource "aws_instance" "web" {
  ami                  = data.aws_ami.this.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}