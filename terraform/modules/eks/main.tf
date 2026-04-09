module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = var.cluster_name
  kubernetes_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  # 🔥 REQUIRED FOR IAM + SERVICE ACCOUNTS
  enable_irsa = true

  # 🔥 EKS MANAGED NODE GROUP (FIXED)
  eks_managed_node_groups = {
    default = {
      desired_size   = 2
      min_size       = 2
      max_size       = 4

      instance_types = ["t3.medium"]

      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"

      # 🔥 CRITICAL FIX (IAM POLICIES)
      iam_role_additional_policies = {
        AmazonEKSWorkerNodePolicy          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
        AmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        AmazonEKS_CNI_Policy               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
      }
    }
  }

  tags = {
    Environment = "dev"
    Project     = "microservices"
  }
}
