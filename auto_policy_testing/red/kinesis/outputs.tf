output "kinesis" {
  value = {
    kinesis                                                        = aws_kinesis_stream.this.arn
    ecc-aws-119-kinesis_streams_encrypted_kms_customer_master_keys = aws_kinesis_stream.this.arn
    ecc-aws-120-kinesis_server_data_at_rest_has_sse                = aws_kinesis_stream.no_sse.arn
    kinesis-video                                                  = aws_kinesis_video_stream.this.arn
  }
}
