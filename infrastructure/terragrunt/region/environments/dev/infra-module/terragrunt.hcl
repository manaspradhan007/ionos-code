include "root" {
  path   = find_in_parent_folders("provider_config.hcl")
  expose = true
}

locals {
  env_vars    = read_terragrunt_config("../../env.hcl")
  region_vars = read_terragrunt_config("../../../region.hcl")
}

terraform {
  source = "${get_repo_root()}/infrastructure/terraform//modules/env-module"
}

inputs = {
  tags = {
    created-by  = "Terragrunt-ionos"
    environment = "${local.env_vars.locals.dev_environment}"
    region      = "${local.region_vars.locals.region}"
    name        = "demoapp"
  }

  #s3:
  # name          = "${local.env_vars.locals.dev_environment}-bucket-01-test"
  # region        = "${local.region_vars.locals.region}"
  # object_lock   = true
  # force_destroy = true

  #k8s:
  region                = "${local.region_vars.locals.region}"
  datacenter_name       = "task-dcd1"
  location              = "de/fra"
  managed_cluster_name  = "task-cluster"
  k8s_version           =  "1.32.5"

  location              = "de/fra"
  registry_name         = "task-container-registry"
  api_subnet_allow_list = []

  #helm-resources:

  nginx_version        = "4.12.2"


  #namespace:
  cluster_name         = "task-cluster"
  kubernetes_namespaces = ["demoapp"]

  #argocd:
  environment          = "${local.env_vars.locals.dev_environment}"
  release_repo_git_access_token = "${get_env("release_repo_git_access_token")}"

  #grafana:
  monitoring_namespace = "monitor"
  grafana_hostname = "grafana.task.de"

  promethues_version  = "75.6.1"

  timeout  = 900
}