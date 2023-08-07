resource "aws_mq_broker" "this" {
  broker_name = "mq-broker-active-434-green"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.1"
  host_instance_type         = "mq.t2.micro"

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "aws_mq_broker" "this1" {
  broker_name = "mq-broker-rabbit-434-green"
  engine_type                = "RabbitMQ"
  engine_version             = "3.10.10"
  host_instance_type         = "mq.t3.micro"
  publicly_accessible        = true
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
