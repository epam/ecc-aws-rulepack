resource "aws_glue_security_configuration" "this" {
  name = "255_security_configuration_green"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = data.aws_kms_key.this.arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
    }

    s3_encryption {
      s3_encryption_mode = "DISABLED"
    }
  }
}

data "aws_kms_key" "this" {
  key_id = "alias/aws/glue"
}