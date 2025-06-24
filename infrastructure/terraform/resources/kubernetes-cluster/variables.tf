variable "region" {
  description = "The region where the Kubernetes cluster will be created."
  type        = string
  default     = "eu-central-3"
}

variable "datacenter_name" {
  description = "name of the datacenter"
  type        = string
}

variable "location" {
  description = "location of the datacenter, e.g. de/fra"
  type        = string
}

variable "managed_cluster_name" {
  description = "name of the managed k8s cluster"
  type        = string
}

variable "k8s_version" {
  description = "version of managed k8s cluster"
  type        = string
}