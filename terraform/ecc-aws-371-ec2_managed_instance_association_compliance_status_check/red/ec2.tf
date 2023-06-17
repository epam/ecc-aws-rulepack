resource "aws_instance" "this" {
  ami                  = "ami-04ad2567c9e3d7893"
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name
  security_groups      = [aws_security_group.this.name]
  
  tags = {
    Name = "371_instance_red"
  }

  depends_on = [aws_security_group.this, aws_iam_instance_profile.this]
}

resource "aws_ssm_association" "this" {
  name                = "AWS-ConfigureAWSPackage"
  association_name    = "371_association_red"
  compliance_severity = "LOW"
  schedule_expression = "rate(30 minutes)"

  parameters = {
    action = "Install"
    installationType = "In-place update"
    name = "AmazonCloudWatchAgent"
  }

  targets {
    key    = "InstanceIds"
    values = [aws_instance.this.id]
  }

  depends_on = [aws_instance.this]
}
