# kubernetes_cluster_role_binding_v1
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/cluster_role_binding_v1

resource "kubernetes_cluster_role_binding_v1" "reader" {
  metadata {
    name = "reader"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = "reader"
    api_group = "rbac.authorization.k8s.io"
  }
  depends_on = [
    kubernetes_role_v1.reader
  ]
}

# kubernetes_role_v1
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/role_v1

resource "kubernetes_role_v1" "reader" {
  metadata {
    name      = "reader"
    namespace = resource.kubernetes_namespace_v1.namespaces.metadata[0].name
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}