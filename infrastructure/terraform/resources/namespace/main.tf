##########################################
# Resource to create Variables
##########################################
resource "kubernetes_namespace" "namespace" {
  for_each = toset(var.kubernetes_namespaces)
  metadata {
    name = each.value
    labels = var.tags
  }
}