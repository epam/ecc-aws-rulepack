resource "aws_sagemaker_endpoint_configuration" "this" {
  name         = "336-endpoint-configuration-green"
  kms_key_arn  = aws_kms_key.this.arn

  production_variants {
    variant_name           = "336-variant-green"
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"

  }
}


resource "aws_sagemaker_model" "this" {
  name                     = "sagemaker-model-336-green"
  execution_role_arn       = aws_iam_role.this.arn
  enable_network_isolation = true

  primary_container {
    image = data.aws_sagemaker_prebuilt_ecr_image.this.registry_path
  }
}

resource "aws_iam_role" "this" {
  assume_role_policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

data "aws_sagemaker_prebuilt_ecr_image" "this" {
  repository_name = "kmeans"
}


resource "aws_kms_key" "this" {
  description             = "Key to encrypt and decrypt Sagemaker"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
}

resource "aws_kms_alias" "this" {
  name          = "alias/336-green"
  target_key_id = aws_kms_key.this.key_id
}