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
}
