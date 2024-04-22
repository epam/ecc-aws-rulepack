data "aws_caller_identity" "this" {}

resource "aws_glacier_vault" "this" {
  name = "308_glacier_vault_red"

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "308_glacier_vault_red",
          "Principal": "*",
          "Effect": "Allow",
          "Action": [
             "glacier:ListVaults"
          ],
          "Resource": "arn:aws:glacier:us-east-1:${data.aws_caller_identity.this.account_id}:vaults/308_glacier_vault_red"
       }
    ]
}
EOF
}