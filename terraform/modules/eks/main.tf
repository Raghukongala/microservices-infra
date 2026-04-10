module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = var.vpc_id

  # ✅ USE PUBLIC SUBNETS (since no NAT)
  subnet_ids = var.public_subnets

  enable_irsa = true

  # ✅ FIXED (v21 syntax)
  cluster_endpoint_access = {
    public  = true
    private = true
  }

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

      # ✅ CRITICAL FIX (no NAT → give public IP)
      associate_public_ip_address = true

      # ✅ IAM POLICIES
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }

      # ✅ Optional (enable if needed)
      # key_name = "your-keypair-name"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "microservices"
  }
}
