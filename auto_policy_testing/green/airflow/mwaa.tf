# It takes about 30 minutes to deploy Airflow Environment

resource "aws_cloudwatch_log_group" "this1" {
  name = "airflow-${local.airflow_name}-Task"
}

resource "aws_cloudwatch_log_group" "this2" {
  name = "airflow-${local.airflow_name}-DAGProcessing"
}
resource "aws_cloudwatch_log_group" "this3" {
  name = "airflow-${local.airflow_name}-Scheduler"
}
resource "aws_cloudwatch_log_group" "this4" {
  name = "airflow-${local.airflow_name}-WebServer"
}
resource "aws_cloudwatch_log_group" "this5" {
  name = "airflow-${local.airflow_name}-Worker"
}

resource "aws_security_group" "this" {
  name        = "${module.naming.resource_prefix.security_group}"
  tags = {
    Name = "${module.naming.resource_prefix.security_group}"
  }
  vpc_id      = data.terraform_remote_state.common.outputs.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [data.terraform_remote_state.common.outputs.vpc_cidr_block]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

locals {
  airflow_name = "${module.naming.resource_prefix.airflow_env}"
}

resource "aws_mwaa_environment" "this" {
  name               = local.airflow_name
  dag_s3_path        = "dags/"
  environment_class = "mw1.small"
  execution_role_arn = aws_iam_role.this.arn
  source_bucket_arn     = aws_s3_bucket.this.arn 
  max_workers = 1
  kms_key = data.terraform_remote_state.common.outputs.kms_key_arn

  network_configuration {
    security_group_ids = [aws_security_group.this.id]
    subnet_ids         = [data.terraform_remote_state.common.outputs.vpc_subnet_private_1_id, data.terraform_remote_state.common.outputs.vpc_subnet_private_2_id]
  }
  
  logging_configuration {
    dag_processing_logs {
      enabled   = true
      log_level = "INFO"
    }
    scheduler_logs {
      enabled   = true
      log_level = "INFO"
    }
    task_logs {
      enabled   = true
      log_level = "INFO"
    }
    webserver_logs {
      enabled   = true
      log_level = "INFO"
    }
    worker_logs {
      enabled   = true
      log_level = "INFO"
    }
  }

}