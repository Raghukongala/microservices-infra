<<<<<<< HEAD
variable "environment" {
  description = "Environment name"
  type        = string
}

variable "repo_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
=======
variable "repo_names" {
  type = list(string)
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
}
