# ---------------------------------------------
# Prometheus and Grafana Monitoring Stack
# ---------------------------------------------

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  version    = "55.4.1" # Stable version

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  # Ensure enough resources for workers to avoid OOM
  set {
    name  = "prometheus.prometheusSpec.resources.requests.memory"
    value = "512Mi"
  }

  depends_on = [module.eks]
}
