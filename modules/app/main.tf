# template_file
# https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file

data "template_file" "kubeconfig" {
  template = file("${path.module}/../templates/kubeconfig.tpl")
  vars = {
    name        = "${var.eks.name}"
    server      = "${var.eks.endpoint}"
    certificate = "${var.eks.certificate_authority[0].data}"
  }
}

resource "local_file" "kubeconfig" {
  content  = data.template_file.kubeconfig.rendered
  filename = "kubeconfig"
  depends_on = [
    data.template_file.kubeconfig
  ]
}

# Data Source: aws_eks_cluster_auth
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth

data "aws_eks_cluster_auth" "eks_cluster" {
  name = var.eks.name
}

# Kubernetes Provider
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs

provider "kubernetes" {
  host                   = var.eks.endpoint
  cluster_ca_certificate = base64decode(var.eks.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
}

locals {
  app_labels = {
    App  = "${var.app_name}"
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
}

# kubernetes_secret
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret

resource "kubernetes_secret" "app_secret" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.namespaces.metadata[0].name
  }
  data = {
    SECRET_KEY = var.secret_key
  }
  depends_on = [
    kubernetes_namespace_v1.namespaces
  ]
}

# kubernetes_service
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service

resource "kubernetes_service" "app-service-internal" {
  metadata {
    name      = "internal-nginx-service"
    namespace = kubernetes_namespace_v1.namespaces.metadata[0].name
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
    kubernetes_namespace_v1.namespaces
  ]
}

resource "kubernetes_service" "app-service-external" {
  metadata {
    name      = "external-nginx-service"
    namespace = kubernetes_namespace_v1.namespaces.metadata[0].name
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
    kubernetes_namespace_v1.namespaces
  ]
}

# kubernetes_deployment
# https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment

resource "kubernetes_deployment" "app" {
  metadata {
    name      = var.app_name
    namespace = kubernetes_namespace_v1.namespaces.metadata[0].name
    labels    = local.app_labels
  }
  spec {
    replicas = 1
    selector {
      match_labels = local.app_labels
    }
    template {
      metadata {
        labels = local.app_labels
      }
      spec {
        container {
          image   = var.docker_image
          name    = var.app_name
          command = ["/bin/sh", "-c", "python manage.py runserver 0.0.0.0:80"]
          port {
            container_port = 80
          }
          env {
            name = "SECRET_KEY"
            value_from {
              secret_key_ref {
                name = var.app_name
                key  = "SECRET_KEY"
              }
            }
          }
        }
      }
    }
  }
  depends_on = [
    var.nodes_group
  ]
}

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
    namespace = kubernetes_namespace_v1.namespaces.metadata[0].name
  }

  rule {
    api_groups = ["*"]
    resources  = ["deployments", "configmaps", "pods", "secrets", "services"]
    verbs      = ["get", "list", "watch"]
  }

  depends_on = [
    kubernetes_namespace_v1.namespaces
  ]
}