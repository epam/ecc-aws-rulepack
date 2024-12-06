resource "aws_instance" "this" {
  ami           = data.aws_ami.this.id
  instance_type = "t2.micro"

  metadata_options {
    http_endpoint = "disabled"
  }
  
  tags = {
    Name             = "224_instance_green2"
    CustodianRule    = "ecc-aws-224-ec2_instance_imdsv2_enabled"
    ComplianceStatus = "Green"
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
