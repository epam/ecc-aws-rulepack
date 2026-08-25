data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "this" {
  state = "available"
}

data "aws_subnet" "az1" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.this.names[0]]
  }
}

data "aws_subnet" "az2" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = [data.aws_availability_zones.this.names[1]]
  }
}
