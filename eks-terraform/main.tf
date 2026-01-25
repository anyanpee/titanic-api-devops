
############################################
# VPC
############################################

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "titanic-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = {
    Project = "titanic-devops"
  }
}

############################################
# EKS Cluster
############################################

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  enable_irsa = true

  eks_managed_node_groups = {
    default = {
      name           = "titanic-ng-default"
      instance_types = [var.node_instance_type]
      min_size       = 1
      max_size       = 3
      desired_size   = 2

      labels = {
        role = "general"
      }

      tags = {
        Name = "titanic-worker-node"
      }
    }
  }

  authentication_mode = "API_AND_CONFIG_MAP"

  tags = {
    Environment = "dev"
    Project     = "titanic-devops"
  }
}

############################################
# IAM User Access Entry
############################################

resource "aws_eks_access_entry" "peter_entry" {
  cluster_name  = module.eks.cluster_name
  principal_arn = "arn:aws:iam::257394496890:user/Peter"
}

############################################
# Attach Cluster Admin Policy
############################################

resource "aws_eks_access_policy_association" "peter_admin_policy" {
  cluster_name  = module.eks.cluster_name
  principal_arn = aws_eks_access_entry.peter_entry.principal_arn
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }
}
