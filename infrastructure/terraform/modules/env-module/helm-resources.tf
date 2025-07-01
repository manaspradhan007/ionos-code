resource "helm_release" "nginx_ingress" {
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  namespace  = "ingress"
  version    = var.nginx_version
  create_namespace = true
    values = [
        file("helm/ingress-values.yaml")
    ]
}