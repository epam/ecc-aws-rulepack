resource "aws_wafregional_web_acl" "this" {
  name        = "524_webacl_red"
  metric_name = "524WebaclMetricRed"

  default_action {
    type = "ALLOW"
  }
}