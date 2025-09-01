resource "aws_waf_rule" "this" {
  name        = "525_waf_rule_red"
  metric_name = "525WafRuleMetricred"
}

resource "aws_waf_rule_group" "this" {
  name        = "525_waf_rule_group_red"
  metric_name = "525WafRuleGroupMetricred"

  activated_rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.this.id
  }
}
