# resource "aws_instance" "this" {
#   ami           = data.aws_ami.this.id
#   instance_type = "t2.micro"

#   tags = {
#     Name = "${module.naming.resource_prefix.ec2_instance}"
#   }
# }

# data "aws_ami" "this" {
#   most_recent = true
#   owners      = ["amazon"]

#   filter {
#     name   = "name"
#     values = ["amzn2-ami-hvm*"]
#   }
# }