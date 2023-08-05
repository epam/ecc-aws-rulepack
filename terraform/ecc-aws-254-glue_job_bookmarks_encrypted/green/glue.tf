resource "aws_glue_security_configuration" "this" {
  name = "254_security_configuration_green"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "DISABLED"
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn = data.aws_kms_key.this.arn
    }

    s3_encryption {
      s3_encryption_mode = "DISABLED"
    }
  }
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/glue"
}