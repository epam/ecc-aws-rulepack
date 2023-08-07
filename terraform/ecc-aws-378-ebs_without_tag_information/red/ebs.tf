resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 8
}