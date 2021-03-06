resource "aws_ecr_repository" "main" {
  name                 = "clublink-backend"
  image_tag_mutability = "MUTABLE"
}