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
  required_version = "~> 1.11.1"
  required_providers {
    ionoscloud = {
      source = "ionos-cloud/ionoscloud"
      version = "6.7.7"
    }
    kubernetes = {
       source  = "hashicorp/kubernetes"
       version = "~> 2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = ">=3.0.1"
    }
  }
}
provider "ionoscloud" {}
provider "kubernetes" {
  config_context = "${local.kubernetes_config_context}"
  config_path    = "~/.kube/config"
}
provider "helm" {
  kubernetes = {
    config_path    = "~/.kube/config"
  }
}
provider "aws" {
  region                      = "de"
  access_key                  = "${get_env("access_key")}"
  secret_key                  = "${get_env("secret_key")}"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_region_validation      = true
  endpoints = "https://s3-eu-central-3.ionoscloud.com"
}
# terraform {
#   backend "s3" {
#     bucket              = "statebucketstore"
#     key                 = "${path_relative_to_include()}/infrastate.tfstate"
#     region              = "eu-central-3"
#     endpoints = {
#       s3  = "https://s3-eu-central-3.ionoscloud.com"
#     }
#     use_path_style    = true                             
#     encrypt             = true     
#     skip_credentials_validation = true
#     skip_requesting_account_id  = true
#   }
# }
EOF
}
inputs = merge(
  local.env_vars.locals,
  local.config_vars.locals
)