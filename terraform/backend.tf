terraform {
  backend "s3" {
    bucket  = "raghu-buk"
    key     = "eks-deploy/terraform.tfstate"
    region  = "ap-south-1"
    encrypt = true
  }
}
