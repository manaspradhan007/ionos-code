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
    environment = local.env_vars.locals.dev_environment
    region      = local.region_vars.locals.region
  }
  name          = "${local.env_vars.locals.dev_environment}-bucket-01"
  region        = local.region_vars.locals.region
  object_lock   = true
  force_destroy = true
}