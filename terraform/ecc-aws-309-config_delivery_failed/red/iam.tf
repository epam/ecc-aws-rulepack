
resource "aws_iam_role" "this" {
  name = "309_role_red"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "this" {
  name = "309_policy_red"
  role = aws_iam_role.this.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": [
        "${aws_s3_bucket.this.arn}",
        "${aws_s3_bucket.this.arn}/*"
      ]
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWS_ConfigRole"
}

resource "null_resource" "this" {
  provisioner "local-exec" {
    command = "aws iam delete-role --role-name ${aws_iam_role.this.name}"
    interpreter = ["/bin/bash", "-c"]
  }
  depends_on = [aws_iam_role_policy.this, aws_config_configuration_recorder_status.this, aws_config_delivery_channel.this]
}