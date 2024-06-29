data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

data "aws_iam_role" "ssm" {
  name = "AWSServiceRoleForAmazonSSM"
}

data "aws_availability_zones" "this" {
  state = "available"
}