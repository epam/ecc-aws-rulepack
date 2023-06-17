resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  provisioner "local-exec" {
    command = "aws ec2 stop-instances --instance-ids ${aws_instance.this.id}"
  }

  tags = {
    Name = "331_instance_green"
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
