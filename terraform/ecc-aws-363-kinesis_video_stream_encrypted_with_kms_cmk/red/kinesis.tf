resource "aws_kinesis_video_stream" "this" {
  name                    = "363_kinesis_stream_red"
  data_retention_in_hours = 1
  media_type              = "video/h264"
}
