resource "aws_mq_broker" "this" {
  broker_name                = "mq-broker-343-green"
  engine_type                = "ActiveMQ"
  engine_version             = "5.17.6"
  host_instance_type         = "mq.t2.micro"
  publicly_accessible        = false

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "random_password" "this" {
  length           = 12
  special          = false
}
