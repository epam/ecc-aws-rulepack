resource "aws_mq_broker" "this" {
  broker_name                = "${module.naming.resource_prefix.message_broker}"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.6"
  host_instance_type         = "mq.t2.micro"
  auto_minor_version_upgrade = true
  publicly_accessible        = true
  deployment_mode            = "ACTIVE_STANDBY_MULTI_AZ"
  security_groups            = [aws_security_group.this.id]
  subnet_ids                 = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  logs {
    audit   = true
    general = true
  }

  encryption_options {
    kms_key_id        = data.terraform_remote_state.common.outputs.kms_key_arn
    use_aws_owned_key = false
  }

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_vpc" "this" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}

resource "aws_subnet" "subnet1" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet2" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

resource "aws_security_group" "this" {
  name   = "345_security_group_green"
  vpc_id = aws_vpc.this.id

  ingress {
    from_port   = 8162
    to_port     = 8162
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
  ingress {
    from_port   = 61617
    to_port     = 61617
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.this.cidr_block]
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
}

# 
resource "aws_mq_broker" "this2" {
  broker_name                = "${module.naming.resource_prefix.message_broker}-2"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.6"
  host_instance_type         = "mq.t2.micro"
  publicly_accessible        = false

  user {
    username = "root"
    password = random_password.this.result
  }
}
