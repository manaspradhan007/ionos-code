#create cluster namespace:
locals {
  domain = var.environment == "prod" ? var.prod_domain : var.dev_domain
}

resource "helm_release" "argocd" {
  name                = "argo"
  chart               = "argo-cd"
  repository          = "https://argoproj.github.io/argo-helm"
  namespace           = "argocd"
  create_namespace    = true
  version             = "7.8.23"
  values = [
    file("argocd-chart-values/argocd/env-values.yaml"),
  ]
  set = [
    {
      name  = "crds.install"
      value = true
    },
    {
      name  = "configs.credentialTemplates.releases-creds.password"
      value = var.release_repo_git_access_token
    },
    {
      name  = "Server.ingress.spec.tls[0].secretName"
      value = "argocd-tls"
    },
    {
      name  = "server.certificateSecret.enabled"
      value = false
    }
  ]
}