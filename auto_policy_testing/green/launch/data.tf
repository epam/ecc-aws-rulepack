data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]
  
  filter {
    name = "name"
	  values = ["amzn2-ami-hvm*"]
  }
}
