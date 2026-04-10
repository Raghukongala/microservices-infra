# terraform/modules/eks/main.tf

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # ──────────────────────────────────────────
  # Cluster Identity
  # ──────────────────────────────────────────
  name               = var.cluster_name
  kubernetes_version = "1.29"

  # ──────────────────────────────────────────
  # Networking
  # ──────────────────────────────────────────
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets   # public subnets (no NAT gateway)

  # ──────────────────────────────────────────
  # API Server Endpoint Access
  # ──────────────────────────────────────────
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # ──────────────────────────────────────────
  # IRSA (IAM Roles for Service Accounts)
  # ──────────────────────────────────────────
  enable_irsa = true

  # ──────────────────────────────────────────
  # Auth — grants cluster-creator admin rights
  # ──────────────────────────────────────────
  enable_cluster_creator_admin_permissions = true

  # ──────────────────────────────────────────
  # Core Addons (required for a working cluster)
  # ──────────────────────────────────────────
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
  }

  # ──────────────────────────────────────────
  # Managed Node Groups
  # ──────────────────────────────────────────
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 2
      max_size       = 4

      instance_types = ["t3.medium"]
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"

      # Required when using public subnets (no NAT)
      associate_public_ip_address = true

      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
    }
  }

  # ──────────────────────────────────────────
  # Tags
  # ──────────────────────────────────────────
  tags = {
    Environment = "dev"
    Project     = "microservices"
  }
}
