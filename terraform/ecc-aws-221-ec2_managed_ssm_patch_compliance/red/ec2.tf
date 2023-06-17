resource "aws_instance" "this" {
  ami                  = data.aws_ami.this.id
  instance_type        = "t2.micro"
  iam_instance_profile = aws_iam_instance_profile.this.name
  security_groups      = [aws_security_group.this.name]

  tags = {
    Name          = "221_instance_red"
    "Patch Group" = "Patch_Group_221_red"
  }
  depends_on = [aws_security_group.this, aws_iam_instance_profile.this]
}

data "aws_ami" "this" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name = "name"
    values = ["amzn2-ami-hvm*"]
  }
}