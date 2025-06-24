variable "release_repo_git_access_token" {
  type        = string
}

variable "install_crds" {
  type = bool
  default = false
}

variable "environment" {
  type = string 
}

variable "prod_domain" {
  type = string
  default = "prod"
}

variable "dev_domain" {
  type = string
  default = "dev"
}
