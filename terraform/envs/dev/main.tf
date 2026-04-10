<<<<<<< HEAD
# ──────────────────────────────────────────
# VPC Module
# ──────────────────────────────────────────
module "vpc" {
  source = "../../modules/vpc"

  environment         = var.environment
  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = var.availability_zones
  cluster_name        = var.cluster_name
}

# ──────────────────────────────────────────
# ECR Module
# ──────────────────────────────────────────
module "ecr" {
  source = "../../modules/ecr"

  environment = var.environment
  repo_names  = var.ecr_repos
}

# ──────────────────────────────────────────
# EKS Module
# ──────────────────────────────────────────
module "eks" {
  source = "../../modules/eks"

  cluster_name       = var.cluster_name
  kubernetes_version = var.kubernetes_version
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnet_ids
  node_desired_size  = var.node_desired_size
  node_min_size      = var.node_min_size
  node_max_size      = var.node_max_size
  node_instance_types = var.node_instance_types
  environment        = var.environment

  depends_on = [module.vpc]
=======
terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source = "../../modules/vpc"

  name = "dev-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = "dev-eks-clusterv2"
  vpc_id          = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
}

module "ecr" {
  source = "../../modules/ecr"

  repo_names = [
    "user-service",
    "product-service",
    "order-service",
    "api-gateway"
  ]
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
}
