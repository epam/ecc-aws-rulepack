resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  tags = {
    Name = "553_instance_red"
  }
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_availability_zones" "this" {
  state = "available"
}

resource "aws_elb" "this" {
  name               = "clb-553-red2"
  availability_zones = data.aws_availability_zones.this.names

  listener {
    instance_port     = 8000
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 31
    target              = "HTTP:8888/"
    interval            = 60
  }
  instances = ["${aws_instance.this.id}"]
}
