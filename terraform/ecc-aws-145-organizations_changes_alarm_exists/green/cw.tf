resource "aws_cloudwatch_log_group" "this" {
  name = "145_log_group_green"
}

resource "aws_cloudwatch_log_stream" "this" {
  name           = "145_log_stream_green"
  log_group_name = aws_cloudwatch_log_group.this.name
}

resource "aws_cloudwatch_log_metric_filter" "this" {
  name           = "145_organizations_changes_green"
  pattern        = "{ ($.eventSource = organizations.amazonaws.com) && (($.eventName = \"AcceptHandshake\") || ($.eventName = \"AttachPolicy\") || ($.eventName = \"CreateAccount\") || ($.eventName = \"CreateOrganizationalUnit\") || ($.eventName = \"CreatePolicy\") || ($.eventName = \"DeclineHandshake\") || ($.eventName = \"DeleteOrganization\") || ($.eventName = \"DeleteOrganizationalUnit\") || ($.eventName = \"DeletePolicy\") || ($.eventName = \"DetachPolicy\") || ($.eventName = \"DisablePolicyType\") || ($.eventName = \"EnablePolicyType\") || ($.eventName = \"InviteAccountToOrganization\") || ($.eventName = \"LeaveOrganization\") || ($.eventName = \"MoveAccount\") || ($.eventName = \"RemoveAccountFromOrganization\") || ($.eventName = \"UpdatePolicy\") || ($.eventName = \"UpdateOrganizationalUnit\")) }"

  log_group_name = aws_cloudwatch_log_group.this.name

  metric_transformation {
    name      = "145_organizations_changes_green"
    namespace = var.namespace
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this" {
  alarm_name                = "145_organizations_changes_green"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "145_organizations_changes_green"
  namespace                 = var.namespace
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this.arn]
}
