resource "aws_mq_broker" "this" {
  broker_name                = module.naming.resource_prefix.message_broker
  engine_type                = "ActiveMQ"
  engine_version             = "5.18"
  host_instance_type         = "mq.t3.micro"
  auto_minor_version_upgrade = true
  publicly_accessible        = true
  provider                   = aws.provider2

  user {
    username = "root"
    password = random_password.this.result
  }
}

resource "random_password" "this" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_+[]{}?"
}
