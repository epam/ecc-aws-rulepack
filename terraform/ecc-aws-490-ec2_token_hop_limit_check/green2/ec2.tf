resource "aws_instance" "this" {
  ami              = data.aws_ami.this.id
  instance_type    = "t2.micro"
  metadata_options {
    http_endpoint = "disabled"
    # `http_put_response_hop_limit` - Defaults to 1
  }
  

  tags = {
    Name = "490_instance_green2"
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
