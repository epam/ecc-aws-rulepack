resource "random_password" "this" {
  length           = 12
  special          = true
  numeric          = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.t2.micro"
  allocated_storage       = 10
  storage_type            = "gp2"
  db_name                 = "database517red"
  username                = "root"
  password                = random_password.this.result
  multi_az                = false
  skip_final_snapshot     = true
  identifier              = "db-instance-571-red"
}

resource "null_resource" "cleanup_rds" {
  depends_on = [
    aws_db_instance.this
  ]
  triggers = {
    profile   = var.profile
    region = var.default-region
    identifier = aws_db_instance.this.identifier
  }
  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<EOF
aws sts get-caller-identity
export AWS_PROFILE=${self.triggers.profile}
export AWS_REGION=${self.triggers.region}
aws sts get-caller-identity

while true; do
  status="$(aws rds describe-db-instances --db-instance-identifier ${self.triggers.identifier} --query DBInstances[0].DBInstanceStatus --output text)"
  if [ "$status" = "available" ]; then
    aws rds stop-db-instance --db-instance-identifier ${self.triggers.identifier}
    break
  else
    echo "Waiting for database: $rds to be available"
    sleep 60
  fi
done
while true; do
  status="$(aws rds describe-db-instances --db-instance-identifier ${self.triggers.identifier} --query DBInstances[0].DBInstanceStatus --output text)"
  if [ "$status" = "stopped" ]; then
    break
  else
    echo "Waiting for database: $rds to be stopped"
    sleep 60
  fi
done

echo "RDS instance stopped."
EOF
  }
}
