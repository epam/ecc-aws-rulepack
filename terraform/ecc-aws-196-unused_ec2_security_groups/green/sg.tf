resource "aws_security_group" "this" {
  name = "196_security_group_green"
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.this.id]
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}