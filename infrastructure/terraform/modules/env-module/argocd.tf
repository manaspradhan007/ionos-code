module "argocdapp" {
  source = "../../resources/argocd"
  release_repo_git_access_token = var.release_repo_git_access_token
  environment = var.environment
}