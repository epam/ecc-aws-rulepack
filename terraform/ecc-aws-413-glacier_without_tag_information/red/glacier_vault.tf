resource "aws_glacier_vault" "this" {
  name = "413_glacier_vault_red"

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "413_glacier_vault_red",
          "Principal": "*",
          "Effect": "Allow",
          "Action": [
             "glacier:ListVaults"
          ],
          "Resource": "arn:aws:glacier:us-east-1:111111111111:vaults/413_glacier_vault_red"
       }
    ]
}
EOF
}