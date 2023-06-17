resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "optional"
    http_endpoint = "enabled"
  }
  
  tags = {
    Name             = "372_instance_red"
    CustodianRule    = "ecc-aws-372-ec2_instance_imdsv2_enabled"
    ComplianceStatus = "Red"
  }  
}

data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	values = ["amzn2-ami-hvm*"]
  }
}
