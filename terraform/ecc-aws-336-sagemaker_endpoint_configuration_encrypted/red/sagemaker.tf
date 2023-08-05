resource "aws_sagemaker_endpoint_configuration" "this" {
  name         = "336-endpoint-configuration-red"

  production_variants {
    variant_name           = "336-variant-red"
    model_name             = aws_sagemaker_model.this.name
    initial_instance_count = 1
    instance_type          = "ml.t2.medium"
  }
}

resource "aws_sagemaker_model" "this" {
  name                     = "sagemaker-model-336-red"
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