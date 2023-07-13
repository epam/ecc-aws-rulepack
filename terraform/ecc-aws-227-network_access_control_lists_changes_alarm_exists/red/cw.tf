resource "aws_cloudwatch_log_group" "this" {
  name = "227_log_group_red1"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "227_log_stream_red1"
  log_group_name = aws_cloudwatch_log_group.this.name
}
