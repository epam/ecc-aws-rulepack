resource "aws_ecr_repository" "this" {
  name           = "230_ecr_respository_green"

  image_scanning_configuration {
    scan_on_push = true
  }
}
