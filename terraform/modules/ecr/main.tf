<<<<<<< HEAD
# ──────────────────────────────────────────
# ECR Repositories
# ──────────────────────────────────────────
resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)

  name                 = each.key
  image_tag_mutability = "MUTABLE"

=======
resource "aws_ecr_repository" "repos" {
  for_each = toset(var.repo_names)

  name                 = each.value
  image_tag_mutability = "MUTABLE"

  force_delete = true

>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
  image_scanning_configuration {
    scan_on_push = true
  }

<<<<<<< HEAD
  tags = {
    Name        = each.key
    Environment = var.environment
  }
}

# ──────────────────────────────────────────
# ECR Lifecycle Policy (keep last 10 images)
# ──────────────────────────────────────────
resource "aws_ecr_lifecycle_policy" "repos" {
  for_each   = aws_ecr_repository.repos
  repository = each.value.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
=======
  lifecycle {
    prevent_destroy = false
    ignore_changes  = all
  }
}
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
