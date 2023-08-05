resource "aws_ecr_repository" "this" {
  name           = "230_ecr_repository_red"


  image_scanning_configuration {
    scan_on_push = false
  }
}
