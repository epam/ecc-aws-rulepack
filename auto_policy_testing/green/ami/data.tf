data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["self"]
  filter {
    name   = "name"
    values = ["${module.naming.resource_prefix.ami}_from_instance"]
  }
  depends_on = [aws_ami_from_instance.this]
}