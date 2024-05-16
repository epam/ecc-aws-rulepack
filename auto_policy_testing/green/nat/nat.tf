resource "aws_security_group" "this" {
  name   = "${module.naming.resource_prefix.security_group}"
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
}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
}

resource "aws_internet_gateway" "this" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
}

resource "aws_route_table" "public" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_2_id
  route_table_id = aws_route_table.public.id
}

resource "aws_eip" "this" { }

resource "aws_route_table" "private" {
  vpc_id = data.terraform_remote_state.common.outputs.vpc_id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this.id
  }
}

resource "aws_route_table_association" "private" {
  subnet_id      = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  route_table_id = aws_route_table.private.id
}

resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  user_data              = file("userdata.sh")
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id              = data.terraform_remote_state.common.outputs.vpc_subnet_1_id
  iam_instance_profile   = aws_iam_instance_profile.this.name
  key_name               = "anna_shcherbak_key"
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
    # interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
aws ec2 wait instance-status-ok --instance-ids ${self.triggers.instance_id}

command_id=$(aws ssm send-command --instance-ids ${self.triggers.instance_id} --document-name "AWS-RunShellScript" --parameters commands="ping -c 20 google.com ; ping -c 20 aws.amazon.com"  --query 'Command.CommandId' --output text)
sleep 60
aws ssm list-command-invocations --command-id $command_id --details --query 'CommandInvocations[0]'

EOF
  }
}

resource "aws_iam_role" "this" {
  name = "${module.naming.resource_prefix.nat_gateway}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = "${module.naming.resource_prefix.nat_gateway}"
  role = aws_iam_role.this.name
}
