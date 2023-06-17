resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_elb" "this" {
  name               = "elb-093-http-red"
  availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  instances                   = ["${aws_instance.this.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400
}