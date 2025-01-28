resource "aws_kms_key" "this" {
  description             = "CustodianRule ecc-aws-110-ecs_cluster_at_rest_encryption"
  enable_key_rotation     = true
  deletion_window_in_days = 20
}

resource "aws_kms_alias" "this" {
  name          = "alias/110-key-green2"
  target_key_id = aws_kms_key.this.key_id
}

resource "aws_kms_key_policy" "this" {
  key_id = aws_kms_key.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Id      = "key-default-1"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow generate data key access for Fargate tasks"
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action   = "kms:GenerateDataKeyWithoutPlaintext"
        Resource = "*"
        Condition = {
          "StringEquals" : {
            "kms:EncryptionContext:aws:ecs:clusterAccount" : [data.aws_caller_identity.this.account_id],
            "kms:EncryptionContext:aws:ecs:clusterName" : [local.cluster_name]
          }
        }
      },
      {
        Sid    = "Allow grant creation permission for Fargate tasks"
        Effect = "Allow"
        Principal = {
          Service = "fargate.amazonaws.com"
        }
        Action   = "kms:CreateGrant"
        Resource = "*"
        Condition = {
          "StringEquals" : {
            "kms:EncryptionContext:aws:ecs:clusterAccount" : [data.aws_caller_identity.this.account_id],
            "kms:EncryptionContext:aws:ecs:clusterName" : [local.cluster_name]
          },
          "ForAllValues:StringEquals" : {
            "kms:GrantOperations" : ["Decrypt"]
          }
        }
      }
    ]
  })
}