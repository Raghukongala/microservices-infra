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
  subnet_ids = var.public_subnets

  # ──────────────────────────────────────────
  # API Endpoint Access  ← v21 exact names
  # ──────────────────────────────────────────
  endpoint_public_access  = true
  endpoint_private_access = true

  # ──────────────────────────────────────────
  # IRSA
  # ──────────────────────────────────────────
  enable_irsa = true

  # ──────────────────────────────────────────
  # Auth
  # ──────────────────────────────────────────
  enable_cluster_creator_admin_permissions = true

  # ──────────────────────────────────────────
  # Addons  ← v21 uses "addons" not "cluster_addons"
  # ──────────────────────────────────────────
  addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true
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

      # Required — public subnets, no NAT gateway
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
