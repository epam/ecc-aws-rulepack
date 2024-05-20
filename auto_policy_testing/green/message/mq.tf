# MQ takes about 10 minutes to deploy

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_+[]{}?"
}

resource "aws_mq_broker" "this" {
  broker_name                = "${module.naming.resource_prefix.message_broker}"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.6"
  host_instance_type         = "mq.t2.micro"
  auto_minor_version_upgrade = true
  publicly_accessible        = false
  deployment_mode            = "ACTIVE_STANDBY_MULTI_AZ"
  security_groups            = [aws_security_group.this.id]
  subnet_ids                 = [data.terraform_remote_state.common.outputs.vpc_subnet_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_3_id]

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

resource "aws_mq_broker" "this2" {
  broker_name        = "${module.naming.resource_prefix.message_broker}-2"
  engine_type        = "RabbitMQ"
  engine_version     = "3.12.13"
  host_instance_type = "mq.m5.large"
  deployment_mode    = "CLUSTER_MULTI_AZ"

  logs {
    general = true
  }

  user {
    username = "root"
    password = random_password.this.result
  }
}