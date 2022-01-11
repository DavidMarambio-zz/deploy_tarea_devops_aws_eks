# Data Source: aws_eks_cluster_auth
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks.name
}

# Kubernetes Provider
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

provider "kubernetes" {
  host                   = aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

locals {
  app_labels = {
    App  = var.app_name
    Tier = "frontend"
  }
}

# kubernetes_namespace_v1
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace_v1

resource "kubernetes_namespace_v1" "namespaces" {
  metadata {
    annotations = {
      name = var.name
    }

    labels = {
      namespace = var.namespace
    }

    name = var.namespace
  }
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}