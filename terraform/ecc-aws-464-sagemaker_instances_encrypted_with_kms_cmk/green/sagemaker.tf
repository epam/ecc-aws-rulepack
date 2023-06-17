resource "aws_sagemaker_notebook_instance" "this" {
  name                   = "464-sagemaker-notebook-instance-green"
  role_arn               = aws_iam_role.this.arn
  instance_type          = "ml.t2.medium"
  kms_key_id             = aws_kms_key.this.arn
}


resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Sagemaker"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/464-green"
  target_key_id = aws_kms_key.this.key_id
}



resource "aws_iam_role" "this" {
  name = "464_role_green"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "sagemaker.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}
