# MQ takes about 10 minutes to deploy

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_mq_broker" "this" {
  provider                   = aws.provider2
  broker_name                = module.naming.resource_prefix.message_broker
  engine_type                = "ActiveMQ"
  engine_version             = "5.16.7"
  host_instance_type         = "mq.t2.micro"
  auto_minor_version_upgrade = false
  publicly_accessible        = true
  security_groups            = [aws_security_group.this.id]
  subnet_ids                 = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id]

  encryption_options {
    use_aws_owned_key = true
  }

  user {
    username = "root"
    password = random_password.this.result
  }
}


resource "aws_mq_broker" "this2" {
  broker_name        = "${module.naming.resource_prefix.message_broker}-2"
  engine_type        = "RabbitMQ"
  engine_version     = "3.11.28"
  host_instance_type = "mq.t3.micro"

  user {
    username = "root"
    password = random_password.this.result
  }
}