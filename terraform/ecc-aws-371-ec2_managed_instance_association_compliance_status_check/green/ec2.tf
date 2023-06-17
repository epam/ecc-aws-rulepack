resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name
  security_groups      = [aws_security_group.this.name]
  
  tags = {
    Name = "371_instance_green"
  }

  depends_on = [aws_security_group.this, aws_iam_instance_profile.this]
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_ssm_association" "this" {
  name                = "AWS-UpdateSSMAgent"
  association_name    = "371_association_green"
  compliance_severity = "MEDIUM"
  schedule_expression = "rate(30 minutes)"

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  depends_on = [aws_instance.this]
}