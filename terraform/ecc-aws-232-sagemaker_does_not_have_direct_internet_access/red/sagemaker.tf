resource "aws_sagemaker_notebook_instance" "this" {
  name                   = "sagemaker-notebook-instance-232-red"
  role_arn               = aws_iam_role.this.arn
  instance_type          = "ml.t2.medium"
  subnet_id              = aws_subnet.this.id
  security_groups        = [aws_security_group.this.id]
  direct_internet_access = "Enabled"
}

resource "aws_iam_role" "this" {
  name = "232_iam_role_red"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_subnet" "this" {
  vpc_id     = aws_vpc.this.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_security_group" "this" {
  name   = "allow_tls"
  vpc_id = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
