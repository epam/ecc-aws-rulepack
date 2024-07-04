resource "aws_instance" "this1" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  disable_api_termination     = true
  iam_instance_profile        = aws_iam_instance_profile.this.name
  monitoring                  = true
  subnet_id                   = data.terraform_remote_state.common.outputs.vpc_subnet_1_id

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    delete_on_termination = true
    volume_size           = 8
  }

  tags = {
    Name          = "${module.naming.resource_prefix.ec2}"
    "Patch Group" = "${module.naming.resource_prefix.ec2}-patch-group"
  }
}

resource "aws_instance" "this2" {
  ami                         = data.aws_ami.this.id
  instance_type               = "t2.micro"
  iam_instance_profile        = aws_iam_instance_profile.this.name
  subnet_id                   = data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id
  associate_public_ip_address = false
}

resource "null_resource" "this1" {
  triggers = {
    instance = aws_instance.this1.id
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws ec2 modify-instance-attribute --instance-id  ${self.triggers.instance} --no-disable-api-termination"
  }

  depends_on = [aws_instance.this1]
}