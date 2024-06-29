data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_caller_identity" "this" {}