resource "aws_mq_broker" "this" {
  broker_name         = "mq-broker-508-red"
  engine_type         = "ActiveMQ"
  engine_version      = "5.15.9"
  host_instance_type  = "mq.t2.micro"
  publicly_accessible = true
  deployment_mode     = "ACTIVE_STANDBY_MULTI_AZ"
  security_groups     = [aws_security_group.this.id]
  subnet_ids          = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "random_password" "this" {
  length = 12
}

