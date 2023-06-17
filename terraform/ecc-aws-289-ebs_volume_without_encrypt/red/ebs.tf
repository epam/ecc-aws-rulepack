resource "aws_ebs_volume" "this" {
  availability_zone = "us-east-1a"
  size              = 5
  
  tags = {
    Name = "289-ebs-volume-red"
  }
}