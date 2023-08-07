resource "aws_instance" "this" {
  ami              = data.aws_ami.this.id
  instance_type    = "t2.micro"
  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 5 
  }
  

  tags = {
    Name = "490_instance_red"
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
