resource "aws_waf_web_acl" "this" {
  name        = "917_webacl_red"
  metric_name = "917WebaclMetricRed"

  default_action {
    type = "ALLOW"
  }

}