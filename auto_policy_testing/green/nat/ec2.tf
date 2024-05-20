resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  user_data              = file("userdata.sh")
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id              = aws_subnet.this.id
  iam_instance_profile   = aws_iam_instance_profile.this.name

  tags = {
    Name = "${module.naming.resource_prefix.ec2_instance}"
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

resource "null_resource" "cleanup_rds" {
  depends_on = [
    aws_instance.this,
    aws_nat_gateway.this,
    aws_route_table_association.private
  ]
  triggers = {
    instance_id = aws_instance.this.id
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.triggers.instance_id}

command_id=$(aws ssm send-command --instance-ids ${self.triggers.instance_id} --document-name "AWS-RunShellScript" --parameters commands="ping -c 50 google.com ; ping -c 50 aws.amazon.com"  --query 'Command.CommandId' --output text)
sleep 60
aws ssm list-command-invocations --command-id $command_id --details --query 'CommandInvocations[0]'
sleep 15m
EOF
  }
}

resource "aws_security_group" "this" {
  name   = module.naming.resource_prefix.security_group
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = module.naming.resource_prefix.security_group
  }
}