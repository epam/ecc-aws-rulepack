resource "aws_glue_security_configuration" "this" {
  name = module.naming.resource_prefix.glue_security_configuration

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "SSE-KMS"
      kms_key_arn                = data.terraform_remote_state.common.outputs.kms_key_arn
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "CSE-KMS"
      kms_key_arn                   = data.terraform_remote_state.common.outputs.kms_key_arn
    }

    s3_encryption {
      s3_encryption_mode = "SSE-KMS"
      kms_key_arn        = data.terraform_remote_state.common.outputs.kms_key_arn
    }
  }
}

