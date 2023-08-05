resource "aws_mq_broker" "this" {
  broker_name                = "mq-broker-340-red"
  engine_type                = "ActiveMQ"
  engine_version             = "5.15.9"
  host_instance_type         = "mq.t2.micro"

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "aws_mq_broker" "this1" {
  broker_name                = "mq-broker-rabbit-340-red"
  engine_type                = "RabbitMQ"
  engine_version             = "3.9.16"
  host_instance_type         = "mq.t3.micro"

  user {
    username = "root"
    password = random_password.this.result
  }
}


resource "random_password" "this" {
  length           = 12
}
