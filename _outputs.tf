output "app_hostname" {
  value = kubernetes_service.app-service-external.status[0].load_balancer[0].ingress[0].hostname
}
