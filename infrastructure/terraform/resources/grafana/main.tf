# This Terraform module deploys Grafana using Helm in a Kubernetes cluster.

#Namespace:

module "namespace" {
    source                = "../../resources/namespace"
    kubernetes_namespaces = [var.monitoring_namespace]
    tags                  = var.tags
}

#random string:
resource "random_string" "grafana_admin_password" {
  length  = 16
  special = false
  upper   = true
  lower   = true
  numeric = true
}

# Kubernetes Secret for Grafana admin password
resource "kubernetes_secret_v1" "grafana_admin_secret" {
  metadata {
    name      = "grafana-admin-secret"
    namespace = var.monitoring_namespace
  }
  data = {
    "admin-password" = base64encode(random_string.grafana_admin_password.result)
    "admin-user"     = base64encode("admin")
  }
  type = "Opaque"
}

#kube prometheus-stack:
resource "helm_release" "kube_prometheus_stack" {
  name       = "k8s-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  version    = var.promethues_version
  namespace  = var.monitoring_namespace
  values = [file("values-files/prometheus-values.yaml")]

  depends_on = [
    module.namespace,
    kubernetes_secret_v1.grafana_admin_secret
  ]

  wait = true
  timeout = var.timeout
}