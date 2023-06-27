resource "aws_iam_role" "this" {
  name = "646_role_green"

  assume_role_policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
        "Effect": "Allow",
        "Principal": {
            "Service": "appsync.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
        }
    ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSAppSyncPushToCloudWatchLogs"
  role       = aws_iam_role.this.name
}

resource "aws_appsync_graphql_api" "this" {
  name                = "646_appsync-graphql-api_green"
  authentication_type = "API_KEY"

  log_config {
    cloudwatch_logs_role_arn = aws_iam_role.this.arn
    field_log_level          = "ERROR"
    exclude_verbose_content  = false
  }
}