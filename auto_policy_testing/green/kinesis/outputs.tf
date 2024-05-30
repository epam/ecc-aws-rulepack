output "kinesis" {
  value = {
    kinesis       = aws_kinesis_stream.this.arn
    kinesis-video = aws_kinesis_video_stream.this.arn
  }
}
