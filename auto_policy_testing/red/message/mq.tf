resource "aws_mq_broker" "this" {
  broker_name                = "${module.naming.resource_prefix.message_broker}"
  engine_type                = "ActiveMQ"
  engine_version             = "5.16.7"
  host_instance_type         = "mq.t2.micro"
  auto_minor_version_upgrade = false
  publicly_accessible        = false 
  provider                   = aws.provider2
  
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
