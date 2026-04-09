terraform {
  backend "s3" {
    bucket         = "eks-terraform-state-bucket"
    key            = "dev/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "eks-terraform-lock"
    encrypt        = true
  }
}
