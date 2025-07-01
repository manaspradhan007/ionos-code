variable "registry_name" {
  type = string
}

variable "location" {
  type        = string
  description = "The location where the container registry will be created, e.g. de/fra"
}

variable "api_subnet_allow_list" {
  type        = list(string)
  description = "List of IP addresses or CIDR ranges that are allowed to access the container registry API"
}