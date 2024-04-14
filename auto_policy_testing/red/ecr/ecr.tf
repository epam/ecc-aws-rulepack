# ecc-aws-228-ecr_immutable_image_tags
# ecc-aws-229-ecr_repository_kms_encryption_enabled
# ecc-aws-230-ecr_image_scanning_on_push_enabled
# ecc-aws-492-ecr_private_lifecycle_policy_configured
resource "aws_ecr_repository" "this" {
  name = module.naming.resource_prefix.ecr_repository

  image_scanning_configuration {
    scan_on_push = false
  }
}
