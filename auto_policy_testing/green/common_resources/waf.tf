resource "aws_wafregional_ipset" "this" {
  name = module.naming.resource_prefix.waf_ip_set

  ip_set_descriptor {
    type  = "IPV4"
    value = "192.0.7.0/24"
  }
}

resource "aws_wafregional_rule" "this" {
  name        = module.naming.resource_prefix.waf_rule
  metric_name = "WafRuleMetricGreen"

  predicate {
    data_id = aws_wafregional_ipset.this.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_web_acl" "this" {
  name        = module.naming.resource_prefix.waf_acl
  metric_name = "WafACLMetricGreen"

  default_action {
    type = "ALLOW"
  }

  rule {
    action {
      type = "BLOCK"
    }

    priority = 1
    rule_id  = aws_wafregional_rule.this.id
  }
}

resource "aws_waf_web_acl" "this" {
  name        = module.naming.resource_prefix.waf_acl
  metric_name = "WafACLMetricGreen"

  default_action {
    type = "ALLOW"
  }
}