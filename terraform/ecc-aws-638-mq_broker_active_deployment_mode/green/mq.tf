resource "aws_mq_broker" "this" {
  broker_name = "mq-broker-active-638-green"
  engine_type                = "ActiveMQ"
  engine_version             = "5.16.4"
  host_instance_type         = "mq.t2.micro"
  deployment_mode            = "ACTIVE_STANDBY_MULTI_AZ"

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "aws_mq_broker" "this1" {
  broker_name = "mq-broker-rabbit-638-green"
  engine_type                = "RabbitMQ"
  engine_version             = "3.9.16"
  host_instance_type         = "mq.m5.large"
  deployment_mode            = "CLUSTER_MULTI_AZ"

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "random_password" "this" {
  length           = 12
  special          = true
  override_special = "!#$%*()-_+[]{}?"
}
