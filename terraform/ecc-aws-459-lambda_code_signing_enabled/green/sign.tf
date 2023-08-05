resource "aws_signer_signing_profile" "this" {
  platform_id = "AWSLambda-SHA384-ECDSA"
  name_prefix = "lambda_459_green"

  signature_validity_period {
    value = 12
    type  = "DAYS"
  }
}

resource "aws_lambda_code_signing_config" "this" {
  allowed_publishers {
    signing_profile_version_arns = [
      aws_signer_signing_profile.this.arn
    ]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }
}
