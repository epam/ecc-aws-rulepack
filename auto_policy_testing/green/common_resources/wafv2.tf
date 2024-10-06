resource "aws_wafv2_ip_set" "this" {
  name = "${module.naming.resource_prefix.waf_ip_set}-${random_integer.this.result}"
  scope              = "REGIONAL"
  ip_address_version = "IPV4"
  addresses          = ["192.0.7.0/24"]
}

resource "aws_wafv2_rule_group" "this" {
  name     = "${module.naming.resource_prefix.waf_rule}-${random_integer.this.result}"
  scope    = "REGIONAL"
  capacity = 1

  rule {
    name     = "rule-1"
    priority = 1

    action {
      allow {}
    }

    statement {

      ip_set_reference_statement {
            arn = aws_wafv2_ip_set.this.arn
          }
    }

    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "WafRuleMetricGreen"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "WafMetricGreen"
    sampled_requests_enabled   = false
  }
}

resource "aws_wafv2_web_acl" "this" {
  name  = "${module.naming.resource_prefix.waf_acl}-v2-${random_integer.this.result}"
  scope = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "rule-1"
    priority = 1

    override_action {
      none {}
    }

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.this.arn
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = false
      metric_name                = "WafACLRuleMetricGreen"
      sampled_requests_enabled   = false
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = false
    metric_name                = "WafACLMetricGreen"
    sampled_requests_enabled   = false
  }
}
