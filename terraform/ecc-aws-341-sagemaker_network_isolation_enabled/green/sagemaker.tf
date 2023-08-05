resource "aws_sagemaker_model" "this" {
  name                     = "sagemaker-model-341-green"
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
