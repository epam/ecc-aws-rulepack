# There is a bug where 'associate_public_ip_address' has a 3 states when terraform can only provide 2 states.
data "aws_ami" "this" {
  most_recent = true

  filter {
    name = "name"
    values = ["amzn2-ami-*-hvm-*-arm64-gp2"]
  }

  filter {
    name = "architecture"
    values = ["arm64"]
  }

  owners = ["amazon"]
}

resource "null_resource" "this" {

  provisioner "local-exec" {
    command = "aws autoscaling create-launch-configuration --launch-configuration-name 364_launch_template_green --image-id ${data.aws_ami.this.id} --instance-type t2.micro --no-associate-public-ip-address"
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws autoscaling delete-launch-configuration --launch-configuration-name 364_launch_template_green"
    interpreter = ["/bin/bash", "-c"]
  }
}