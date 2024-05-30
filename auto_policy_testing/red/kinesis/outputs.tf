output "kinesis" {
  value = {
    kinesis                                         = aws_kinesis_stream.this1.arn
    kinesis-video                                   = aws_kinesis_video_stream.this.arn
    ecc-aws-120-kinesis_server_data_at_rest_has_sse = aws_kinesis_stream.this2.arn
  }
}
