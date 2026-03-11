# ---------------------------------------------
# Monitoring Outputs
# ---------------------------------------------

data "kubernetes_service" "grafana" {
  metadata {
    name      = "prometheus-grafana"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
  }
  depends_on = [helm_release.prometheus]
}

output "grafana_url" {
  description = "Grafana Dashboard URL"
  value       = try(
    "http://${data.kubernetes_service.grafana.status[0].load_balancer[0].ingress[0].hostname}",
    "Grafana LoadBalancer is warming up... please wait."
  )
}

output "grafana_admin_password" {
  description = "Grafana Admin Password (Default)"
  value       = "prom-operator"
}
