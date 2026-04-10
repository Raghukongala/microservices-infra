resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  # ✅ DEV SAFE: allows destroy even if images exist
  force_delete = true

  image_scanning_configuration {
    scan_on_push = true
  }

  # ✅ DEV ONLY: prevents accidental issues during iterations
  lifecycle {
    prevent_destroy = false
  }
}
