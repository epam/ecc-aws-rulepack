resource "random_password" "this" {
  length           = 12
  special          = true
  number           = true
  override_special = "!#$%*()-_=+[]{}:?"
}

resource "aws_db_instance" "this" {
  allocated_storage    = 10
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  db_name              = "database346green"
  username             = "root"
  password             = random_password.this.result
  parameter_group_name = "default.mysql5.7"
  monitoring_role_arn  = aws_iam_role.this.arn
  skip_final_snapshot  = true
  monitoring_interval  = 30

  tags = {
    Name = "346_db_instance_green"
  }
}

resource "aws_iam_role" "this" {
  name = "346-role-green"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "monitoring.rds.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

data "aws_iam_policy" "this" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = data.aws_iam_policy.this.arn
}
