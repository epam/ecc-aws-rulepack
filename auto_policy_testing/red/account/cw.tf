resource "aws_cloudwatch_log_group" "this1" {
  name = "${module.naming.resource_prefix.cw_log_group}-1"
}

resource "aws_cloudwatch_log_group" "this2" {
  name = "${module.naming.resource_prefix.cw_log_group}-2"
}

resource "aws_cloudwatch_event_rule" "this" {
  name = module.naming.resource_prefix.event_rule
  event_pattern = <<EOF
{
  "detail-type": [
    "AWS Console Sign In via CloudTrail"
  ]
}
EOF
}


# wrong pattern
resource "aws_cloudwatch_log_metric_filter" "this1" {
  name    = "${module.naming.resource_prefix.cw_log_group}-067"
  pattern = "{(($.errorCode=\"AccessDenied*\")) && (($.sourceIPAddress!=\"delivery.logs.amazonaws.com\") && ($.eventName!=\"HeadBucket\"))}"

  log_group_name = aws_cloudwatch_log_group.this1.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-067"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this1" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-067"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-067"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------
# wrong pattern
resource "aws_cloudwatch_log_metric_filter" "this2" {
  name    = "${module.naming.resource_prefix.cw_log_group}-077"
  pattern = "{($.eventName = \"ConsoleLogin\") || ($.additionalEventData.MFAUsed != \"Yes\") && ($.userIdentity.type = \"IAMUser\") && ($.responseElements.ConsoleLogin = \"Success\")}"

  log_group_name = aws_cloudwatch_log_group.this1.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-077"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this2" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-077"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-077"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this3" {
  name    = "${module.naming.resource_prefix.cw_log_group}-078"
  pattern = "{ $.userIdentity.type = \"Root\" && $.userIdentity.invokedBy NOT EXISTS && $.eventType != \"AwsServiceEvent\" }"

  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-078"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this3" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-078"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-078"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------
# wrong pattern
resource "aws_cloudwatch_log_metric_filter" "this4" {
  name    = "${module.naming.resource_prefix.cw_log_group}-079"
  pattern = "{($.eventName=DeleteGroupPolicy) || ($.eventName=DeleteRolePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=PutGroupPolicy) || ($.eventName=PutRolePolicy) || ($.eventName=PutUserPolicy) || ($.eventName=CreatePolicy) || ($.eventName=DeleteUserPolicy) || ($.eventName=CreatePolicyVersion) || ($.eventName=DeletePolicyVersion) || ($.eventName=AttachRolePolicy) || ($.eventName=DetachRolePolicy) || ($.eventName=AttachUserPolicy) || ($.eventName=DetachUserPolicy) || ($.eventName=AttachGroupPolicy) || ($.eventName=DetachGroupPolicy)}"

  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-079"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this4" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-079"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-079"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this5" {
  name           = "${module.naming.resource_prefix.cw_log_group}-080"
  pattern        = "{ ($.eventName = CreateTrail) || ($.eventName = UpdateTrail) || ($.eventName = DeleteTrail) || ($.eventName = StartLogging) || ($.eventName = StopLogging) }"
  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-080"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this5" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-080"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-080"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this1.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this6" {
  name    = "${module.naming.resource_prefix.cw_log_group}-081"
  pattern = "{($.eventName = ConsoleLogin) && ($.errorMessage = \"Failed authentication\")}"

  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-081"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this6" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-081"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-081"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this7" {
  name           = "${module.naming.resource_prefix.cw_log_group}-082"
  pattern        = "{ ($.eventSource = kms.amazonaws.com) && (($.eventName=DisableKey)||($.eventName=ScheduleKeyDeletion)) }"
  log_group_name = aws_cloudwatch_log_group.this1.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-082"
    namespace = "API_Calls"
    value     = "1"
  }
}
// no alarm
resource "aws_cloudwatch_metric_alarm" "this7" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-082"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-082"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this8" {
  name    = "${module.naming.resource_prefix.cw_log_group}-094"
  pattern = "{($.eventSource = s3.amazonaws.com) && (($.eventName = PutBucketAcl) || ($.eventName = PutBucketPolicy) || ($.eventName = PutBucketCors) || ($.eventName = PutBucketLifecycle) || ($.eventName = PutBucketReplication) || ($.eventName = DeleteBucketPolicy) || ($.eventName = DeleteBucketCors) || ($.eventName = DeleteBucketLifecycle) || ($.eventName = DeleteBucketReplication))}"

  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-094"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this8" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-094"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-094"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------
# wrong pattern
resource "aws_cloudwatch_log_metric_filter" "this9" {
  name           = "${module.naming.resource_prefix.cw_log_group}-095"
  pattern        = "{ ($.eventSource = config.amazonaws.com) || ($.eventName=StopConfigurationRecorder)||($.eventName=DeleteDeliveryChannel)||($.eventName=PutDeliveryChannel)||($.eventName=PutConfigurationRecorder) }"
  log_group_name = aws_cloudwatch_log_group.this1.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-095"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this9" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-095"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-095"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this10" {
  name           = "${module.naming.resource_prefix.cw_log_group}-096"
  pattern        = "{($.eventName = AuthorizeSecurityGroupIngress) || ($.eventName = AuthorizeSecurityGroupEgress) || ($.eventName = RevokeSecurityGroupIngress) || ($.eventName = RevokeSecurityGroupEgress) || ($.eventName = CreateSecurityGroup) || ($.eventName = DeleteSecurityGroup)}"
  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-096"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this10" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-096"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-096"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this11" {
  name           = "${module.naming.resource_prefix.cw_log_group}-097"
  pattern        = "{ ($.eventName = CreateNetworkAcl) || ($.eventName = CreateNetworkAclEntry) || ($.eventName = DeleteNetworkAcl) || ($.eventName = DeleteNetworkAclEntry) || ($.eventName = ReplaceNetworkAclEntry) || ($.eventName = ReplaceNetworkAclAssociation) }"
  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-097"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this11" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-097"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-097"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this12" {
  name    = "${module.naming.resource_prefix.cw_log_group}-098"
  pattern = "{ ($.eventName = CreateCustomerGateway) || ($.eventName = DeleteCustomerGateway) || ($.eventName = AttachInternetGateway) || ($.eventName = CreateInternetGateway) || ($.eventName = DeleteInternetGateway) || ($.eventName = DetachInternetGateway) }"

  log_group_name = aws_cloudwatch_log_group.this2.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-098"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this12" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-098"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-098"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this13" {
  name           = "${module.naming.resource_prefix.cw_log_group}-099"
  pattern        = "{($.eventName = CreateRoute) || ($.eventName = CreateRouteTable) || ($.eventName = ReplaceRoute) || ($.eventName = ReplaceRouteTableAssociation) || ($.eventName = DeleteRouteTable) || ($.eventName = DisassociateRouteTable)}"
  log_group_name = aws_cloudwatch_log_group.this1.name

  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-099"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this13" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-099"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-099"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this1.arn]
}

// ------------

resource "aws_cloudwatch_log_metric_filter" "this14" {
  name           = "${module.naming.resource_prefix.cw_log_group}-100"
  pattern        = "{($.eventName = CreateVpc) || ($.eventName = DeleteVpc) || ($.eventName = AcceptVpcPeeringConnection) || ($.eventName = CreateVpcPeeringConnection) || ($.eventName = DeleteVpcPeeringConnection) || ($.eventName = RejectVpcPeeringConnection) || ($.eventName = AttachClassicLinkVpc) || ($.eventName = DetachClassicLinkVpc) || ($.eventName = DisableVpcClassicLink) || ($.eventName = EnableVpcClassicLink)}"
  log_group_name = aws_cloudwatch_log_group.this2.name


  metric_transformation {
    name      = "${module.naming.resource_prefix.cw_log_group}-100"
    namespace = "API_Calls"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "this14" {
  alarm_name                = "${module.naming.resource_prefix.cw_log_group}-100"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "${module.naming.resource_prefix.cw_log_group}-100"
  namespace                 = "API_Calls"
  period                    = "300"
  statistic                 = "Sum"
  threshold                 = "1"
  alarm_description         = ""
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.this2.arn]
}
