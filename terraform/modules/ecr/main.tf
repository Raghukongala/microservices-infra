resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}
