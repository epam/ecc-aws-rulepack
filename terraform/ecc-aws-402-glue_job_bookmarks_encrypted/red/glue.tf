resource "aws_glue_security_configuration" "this" {
  name = "402_security_configuration_red"

  encryption_configuration {
    cloudwatch_encryption {
      cloudwatch_encryption_mode = "DISABLED"
    }

    job_bookmarks_encryption {
      job_bookmarks_encryption_mode = "DISABLED"
    }

    s3_encryption {
      s3_encryption_mode = "DISABLED"
    }
  }
}

