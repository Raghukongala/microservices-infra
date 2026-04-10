<<<<<<< HEAD
=======
# terraform/modules/eks/main.tf

>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  # ──────────────────────────────────────────
  # Cluster Identity
  # ──────────────────────────────────────────
  name               = var.cluster_name
<<<<<<< HEAD
  kubernetes_version = var.kubernetes_version
=======
  kubernetes_version = "1.29"
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137

  # ──────────────────────────────────────────
  # Networking
  # ──────────────────────────────────────────
  vpc_id     = var.vpc_id
  subnet_ids = var.public_subnets

  # ──────────────────────────────────────────
<<<<<<< HEAD
  # API Endpoint Access (v21 exact names)
=======
  # API Endpoint Access  ← v21 exact names
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
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
<<<<<<< HEAD
  # Addons (v21 uses "addons" not "cluster_addons")
=======
  # Addons  ← v21 uses "addons" not "cluster_addons"
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
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
<<<<<<< HEAD
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      instance_types = var.node_instance_types
=======
      desired_size   = 2
      min_size       = 2
      max_size       = 4
      instance_types = ["t3.medium"]
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
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
<<<<<<< HEAD
    Environment = var.environment
=======
    Environment = "dev"
>>>>>>> ffcac67a74213d11886f199667ede2a33d505137
    Project     = "microservices"
  }
}
