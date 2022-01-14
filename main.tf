provider "aws" {
  profile = var.profile
  region  = var.region
}

resource "random_string" "suffix" {
  length  = 8
  special = false
}

locals {
  cluster_name = "eks-${random_string.suffix.result}"
}

module "vpc" {
  source = "./modules/vpc_eks"
  # The CIDR block for the VPC.
  cidr = var.cidr
  # The CIDR block for the subnet public 1.
  cidr_public_1 = var.cidr_public_1
  # The AZ for the subnet public 1.
  az_public_1 = var.az_public_1
  # The CIDR block for the subnet public 2.
  cidr_public_2 = var.cidr_public_2
  # The AZ for the subnet public 2.
  az_public_2 = var.az_public_2
  # The CIDR block for the subnet private 1.
  cidr_private_1 = var.cidr_private_1
  # The AZ for the subnet private 1.
  az_private_1 = var.az_private_1
  # The CIDR block for the subnet private 2.
  cidr_private_2 = var.cidr_private_2
  # The AZ for the subnet private 2.
  az_private_2 = var.az_private_2
  # Name of the clustes EKS.
  cluster_name = local.cluster_name
}

module "eks" {
  source = "./modules/eks"
  # Name of the clustes EKS.
  cluster_name = local.cluster_name
  # Desire kubernetes master version
  kubernetes_version = var.kubernetes_version
  # Disk size in GiB for worker nodes
  disk_size = 5
  # Instance types EC2
  instance_types = "t2.small"
  # AWS VPC
  vpc = module.vpc.vpc
  # AWS Subnet Public 1
  subnet_public_1_id = module.vpc.subnet_public_1.id
  # AWS Subnet Public 2
  subnet_public_2_id = module.vpc.subnet_public_2.id
  # AWS Subnet Private 1
  subnet_private_1_id = module.vpc.subnet_private_1.id
  # AWS Subnet Private 2
  subnet_private_2_id = module.vpc.subnet_private_2.id
}

module "app" {
  source = "./modules/app"
  # EKS cluster object
  eks = module.eks.cluster
  # EKS cluster node group object
  nodes_group = module.eks.nodes_group
  # Project name
  name = var.name
  # Application name
  app_name = var.app_name
  # Namespace of the Project
  namespace = var.namespace
  # App Secret Key
  secret_key = var.secret_key
  # App container image
  docker_image = var.docker_image
}