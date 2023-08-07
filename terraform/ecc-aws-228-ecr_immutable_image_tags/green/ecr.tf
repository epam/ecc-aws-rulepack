resource "aws_ecr_repository" "this" {
  name                 = "228_ecr_respository_green"
  image_tag_mutability = "IMMUTABLE"
}
