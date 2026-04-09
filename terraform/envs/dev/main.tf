terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# ---------------- VPC ----------------

module "vpc" {
  source = "../../modules/vpc"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

# ---------------- EKS ----------------

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "dev-eks-cluster"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

# ---------------- ECR ----------------

module "ecr" {
  source = "../../modules/ecr"

  repo_names = [
    "user-service",
    "product-service",
    "order-service",
    "api-gateway"
  ]
}
