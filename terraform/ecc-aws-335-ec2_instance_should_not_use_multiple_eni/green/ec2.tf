resource "aws_instance" "this" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.this.id

  tags = {
    Name = "335_ec2_instance_green"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "this" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}
