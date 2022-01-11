# kubernetes_secret
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret

resource "kubernetes_secret" "app_secret" {
  metadata {
    name      = var.app_name
    namespace = resource.kubernetes_namespace_v1.namespaces.metadata[0].name
  }
  data = {
    SECRET_KEY = var.secret_key
  }
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}