# module "storage" {
#   source        = "../../resources/object-storage"
#   name          = var.name
#   region        = var.region
#   object_lock   = var.object_lock
#   force_destroy = var.force_destroy
#   tags          = var.tags
# }

# module "env-setup" {
#   source = "../../resources/kubernetes-cluster"

#   region              = var.region
#   datacenter_name    = var.datacenter_name
#   location            = var.location
#   managed_cluster_name = var.managed_cluster_name
#   k8s_version         = var.k8s_version

# }

# module "container_registry" {
#   source = "../../resources/container-registry"
#   location                  = var.location
#   registry_name             = var.registry_name
#   api_subnet_allow_list     = var.api_subnet_allow_list
# }

module "namespace" {
  source                = "../../resources/namespace"
  kubernetes_namespaces = var.kubernetes_namespaces
  tags                  = var.tags
}