resource "aws_ecr_repository" "this" {
  name = "377_ecr_respository_green"
  encryption_configuration {
    encryption_type = "KMS"
  }
}
