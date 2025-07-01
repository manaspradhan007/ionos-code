variable "tags" {
  description = "these tags are applied to every resource within this module"
  type        = map(string)
  default = {
    created_by = "terraformed-resources"
  }
}
variable "kubernetes_namespaces" {
  type = list(string)
}