data "aws_availability_zones" "this" {
  state = "available"
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