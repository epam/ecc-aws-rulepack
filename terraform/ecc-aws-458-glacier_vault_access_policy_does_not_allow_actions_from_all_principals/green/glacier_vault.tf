resource "aws_glacier_vault" "this" {
  name = "458_glacier_vault_green"

  access_policy = <<EOF
{
    "Version":"2012-10-17",
    "Statement":[
       {
          "Sid": "458_glacier_vault_green",
          "Principal": {
            "AWS": 
            [ 
              "arn:aws:iam::123456789012:root", 
              "arn:aws:iam::444455556666:root"
            ]
          },
          "Effect": "Allow",
          "Action": [
             "glacier:ListVaults"
          ],
          "Resource": "arn:aws:glacier:us-east-1:123456789012:vaults/458_glacier_vault_green"
       }
    ]
}
EOF
}