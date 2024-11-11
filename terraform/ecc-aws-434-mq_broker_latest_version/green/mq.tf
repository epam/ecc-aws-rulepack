# takes about 10 min to deploy

resource "aws_mq_broker" "this" {
  broker_name = "mq-broker-active-434-green"
  engine_type                = "ActiveMQ"
  engine_version             = "5.18"
  host_instance_type         = "mq.t2.micro"
  auto_minor_version_upgrade = true

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "aws_mq_broker" "this1" {
  broker_name = "mq-broker-rabbit-434-green"
  engine_type                = "RabbitMQ"
  engine_version             = "3.13"
  host_instance_type         = "mq.t3.micro"
  publicly_accessible        = true
  auto_minor_version_upgrade = true
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
