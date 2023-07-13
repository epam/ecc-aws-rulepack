resource "aws_waf_rule" "this" {
  name        = "915_waf_rule_red"
  metric_name = "915WafRuleMetricred"
}

resource "aws_waf_rule_group" "this" {
  name        = "915_waf_rule_group_red"
  metric_name = "915WafRuleGroupMetricred"

  activated_rule {
    action {
      type = "ALLOW"
    }

    priority = 1
    rule_id  = aws_waf_rule.this.id
  }
}
