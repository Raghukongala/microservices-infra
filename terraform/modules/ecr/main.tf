resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)

  name = each.value

  image_scanning_configuration {
    scan_on_push = true
  }
}
