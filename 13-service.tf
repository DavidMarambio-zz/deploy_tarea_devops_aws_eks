# kubernetes_service
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service

resource "kubernetes_service" "app-service-internal" {
  metadata {
    name      = "internal-nginx-service"
    namespace = resource.kubernetes_namespace_v1.namespaces.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                              = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
      "service.beta.kubernetes.io/aws-load-balancer-internal"                          = "0.0.0.0/0"
    }
  }
  spec {
    selector = local.app_labels
    port {
      port     = 80
      protocol = "TCP"
    }
    type = "LoadBalancer"
  }
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}

resource "kubernetes_service" "app-service-external" {
  metadata {
    name      = "external-nginx-service"
    namespace = resource.kubernetes_namespace_v1.namespaces.metadata[0].name
    annotations = {
      "service.beta.kubernetes.io/aws-load-balancer-type"                              = "nlb"
      "service.beta.kubernetes.io/aws-load-balancer-cross-zone-load-balancing-enabled" = "true"
    }
  }
  spec {
    selector = local.app_labels
    port {
      port     = 80
      protocol = "TCP"
    }
    type = "LoadBalancer"
  }
  depends_on = [
    aws_eks_node_group.nodes_general
  ]
}