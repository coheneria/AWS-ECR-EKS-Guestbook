resource "aws_ecr_repository" "guestbook-go" {
  name                 = var.repo-name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_repository" "redis" {
  name                 = "redis"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}