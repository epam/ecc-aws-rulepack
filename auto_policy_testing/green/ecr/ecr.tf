# ecc-aws-228-ecr_immutable_image_tags
# ecc-aws-229-ecr_repository_kms_encryption_enabled
# ecc-aws-230-ecr_image_scanning_on_push_enabled
# ecc-aws-492-ecr_private_lifecycle_policy_configured

resource "aws_ecr_repository" "this" {
  name                 = module.naming.resource_prefix.ecr_repository
  image_tag_mutability = "IMMUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Expire images older than 14 days",
            "selection": {
                "tagStatus": "untagged",
                "countType": "sinceImagePushed",
                "countUnit": "days",
                "countNumber": 14
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
