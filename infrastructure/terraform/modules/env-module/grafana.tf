module "grafana" {
  source = "../../resources/grafana"
  grafana_hostname = var.grafana_hostname
  tags             = var.tags
  promethues_version = var.promethues_version
  timeout          = var.timeout
  monitoring_namespace = var.monitoring_namespace
}

