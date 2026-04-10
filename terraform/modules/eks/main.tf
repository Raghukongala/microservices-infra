module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = var.vpc_id

  # ✅ USE PUBLIC SUBNETS (IMPORTANT)
  subnet_ids = var.public_subnets

  enable_irsa = true

  # ✅ Allow API access (debug + node join)
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # ✅ Automatically manage aws-auth
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 2
      max_size       = 4

      instance_types = ["t3.medium"]

      ami_type      = "AL2_x86_64"
      capacity_type = "ON_DEMAND"

      # ✅ CRITICAL: GIVE PUBLIC IP (NO NAT FIX)
      associate_public_ip_address = true

      # ✅ IAM POLICIES (CORRECT)
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }

      # ✅ Optional (for SSH debugging)
      # key_name = "your-keypair-name"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "microservices"
  }
}
