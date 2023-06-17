resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  tags = {
    Name = "370_instance_red"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}
