resource "aws_instance" "this" {
  ami                    = data.aws_ami.this.id
  instance_type          = "t2.micro"
  user_data              = file("userdata.sh")
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id              = aws_subnet.private.id
  iam_instance_profile   = aws_iam_instance_profile.this.name
  key_name               = "anna_shcherbak_key"
  tags = {
    Name = "573_instance_green"
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

# resource "null_resource" "cleanup_rds" {
#   depends_on = [
#     aws_instance.this,
#     aws_nat_gateway.this,
#     aws_route_table_association.private
#   ]
#   triggers = {
#     instance_id = aws_instance.this.id
#   }
#   provisioner "local-exec" {
#     # interpreter = ["/bin/bash", "-c"]
#     command     = <<EOF
# aws ec2 wait instance-status-ok --instance-ids ${self.triggers.instance_id}

# command_id=$(aws ssm send-command --instance-ids ${self.triggers.instance_id} --document-name "AWS-RunShellScript" --parameters commands="ping -c 20 google.com ; ping -c 20 aws.amazon.com"  --query 'Command.CommandId' --output text)
# sleep 60
# aws ssm list-command-invocations --command-id $command_id --details --query 'CommandInvocations[0]'

# EOF
#   }
# }