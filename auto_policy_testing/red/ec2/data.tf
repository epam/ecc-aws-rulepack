data "aws_ami" "this" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-arm64-gp2"]
  }
}

data "aws_iam_role" "ssm" {
  name = "AWSServiceRoleForAmazonSSM"
}

data "aws_availability_zones" "this" {
  state = "available"
}

# a1.medium is not offered in every AZ; pick one that supports it (needed for dedicated tenancy)
data "aws_ec2_instance_type_offerings" "a1_medium" {
  filter {
    name   = "instance-type"
    values = ["a1.medium"]
  }

  location_type = "availability-zone"
}

locals {
  availability_zone = element(
    sort(tolist(setintersection(
      toset(data.aws_availability_zones.this.names),
      toset(data.aws_ec2_instance_type_offerings.a1_medium.locations)
    ))),
    0
  )
}
