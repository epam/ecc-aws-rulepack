resource "aws_waf_web_acl" "this" {
  name        = "527_webacl_red"
  metric_name = "527WebaclMetricRed"

  default_action {
    type = "ALLOW"
  }

}