resource "aws_glacier_vault" "this" {
  name = "599_glacier_vault_green"

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "599_glacier_vault_green",
          "Principal": "*",
          "Effect": "Allow",
          "Action": [
             "glacier:ListVaults"
          ],
          "Resource": "arn:aws:glacier:us-east-1:111111111111:vaults/599_glacier_vault_green"
       }
    ]
}
EOF
}