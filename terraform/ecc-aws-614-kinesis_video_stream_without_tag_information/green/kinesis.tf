resource "aws_kinesis_video_stream" "this" {
  name                    = "614_kinesis_stream_green"
  data_retention_in_hours = 1
  media_type              = "video/h264"
}
