output "airflow" {
  value = {
    airflow = aws_mwaa_environment.this.arn
  }
}
