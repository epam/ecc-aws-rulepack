
resource "aws_wafregional_ipset" "this" {
  name = "GreenWAFRegionalIPSet"
}

resource "aws_wafregional_rule" "this" {
  name        = "GreenWAFRegionalRule"
  metric_name = "GreenWAFRegionalRule"

  predicate {
    data_id = aws_wafregional_ipset.this.id
    negated = false
    type    = "IPMatch"
  }
}

resource "aws_wafregional_web_acl" "this" {
  name        = "GreenWAFRegionalACL"
  metric_name = "GreenWAFRegionalACL"

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

resource "aws_wafregional_web_acl_association" "this" {
  resource_arn = aws_lb.this.arn
  web_acl_id   = aws_wafregional_web_acl.this.id
}
