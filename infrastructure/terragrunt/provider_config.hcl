locals {
  env_vars                  = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  region_vars               = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  config_vars               = read_terragrunt_config(find_in_parent_folders("config.hcl"))
  kubernetes_config_context = "task-cluster"
}


generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "6.7.7"
    }
    kubernetes = {
       source  = "hashicorp/kubernetes"
       version = "~> 2"
     }
     helm = {
       source  = "hashicorp/helm"
       version = ">= 2.7"
     }
     kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    argocd = {
      source = "argoproj-labs/argocd"
      version = "~> 7.0"
    }
  }
}
provider "ionoscloud" {
  token = "${get_env("IONOS_TOKEN", "default_or_error_if_not_set")}" # Use environment variable for security
  region = "eu-central-3"
}
provider "kubernetes" {
  config_context = "${local.kubernetes_config_context}"
  config_path    = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_context = "${local.kubernetes_config_context}"
    config_path    = "~/.kube/config"
  }
}
terraform {
  backend "s3" {
    bucket              = "tfstatefile"
    key                 = "${path_relative_to_include()}/infrastate.tfstate"
    region              = "eu-central-3"
    endpoint            = "s3.eu-central-3.ionoscloud.com"
    access_key          = "${get_env("access_key")}"       # It's better to use environment variables!
    secret_key          = "${get_env("secret_key")}"       # It's better to use environment variables!
    force_path_style    = true                           # Required for some S3-compatible services
    encrypt             = true                             # Optional: Encrypts the state file at rest
  }
}
EOF
}
inputs = merge(
  local.env_vars.locals,
  local.config_vars.locals
)