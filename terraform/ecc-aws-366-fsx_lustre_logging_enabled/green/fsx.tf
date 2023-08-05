resource "aws_fsx_lustre_file_system" "this" {
  storage_capacity            = 6000
  subnet_ids                  = [data.aws_subnets.this.ids[0]]
  deployment_type             = "PERSISTENT_1"
  storage_type                = "HDD"
  drive_cache_type            = "NONE"
  per_unit_storage_throughput = 12
  log_configuration {
    level       = "WARN_ERROR"
    destination = aws_cloudwatch_log_group.this.arn
  }
  tags = {
    Name = "366-fsx_lustre_file_system-green"
  }
}

resource "aws_cloudwatch_log_group" "this" {
  name = "/aws/fsx/366_lustre_green"
}