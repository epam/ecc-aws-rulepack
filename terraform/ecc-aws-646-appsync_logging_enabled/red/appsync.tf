resource "aws_iam_role" "this" {
  name = "646_role_red"

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
  name                = "646_appsync-graphql-api_red"
  authentication_type = "API_KEY"

}