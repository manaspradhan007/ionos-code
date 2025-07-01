# variable "name" {
#   description = "The name of the object storage bucket."
#   type        = string
# }

# variable "region" {
#   description = "The name of the object storage bucket."
#   type        = string
#   default     = "eu-central-3"
# }

# variable "object_lock" {
#   description = "The name of the object storage bucket."
#   type        = bool
#   default     = false
# }
# variable "force_destroy" {
#   description = "allow/deny force destroy of bucket"
#   type        = bool
#   default     = false
# }

variable "tags" {
  description = "tags"
  type        = map(string)
}


# variable "region" {
#   description = "The region where the Kubernetes cluster will be created."
#   type        = string
#   default     = "eu-central-3"
# }

# variable "datacenter_name" {
#   description = "name of the datacenter"
#   type        = string
# }

# variable "location" {
#   description = "location of the datacenter, e.g. de/fra"
#   type        = string
# }

# variable "managed_cluster_name" {
#   description = "name of the managed k8s cluster"
#   type        = string
# }

# variable "k8s_version" {
#   description = "version of managed k8s cluster"
#   type        = string
# }

#container registry variables
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

variable "cluster_name" {
  type = string
  description = "name of the Kubernetes cluster to use in kubectl config"
}

variable "kubernetes_namespaces" {
  type = list(string)
}

variable "nginx_version" {
  type = string
}

#ARGOCD:

variable "release_repo_git_access_token" {
  type        = string
}
variable "environment" {
  type = string 
}


#grafana:

variable "grafana_hostname" {
  type        = string
  description = "The hostname for the Grafana instance"   
}

variable "promethues_version" {
  type = string
  description = "value of the grafana version to be used"
}

variable "timeout" {
  type        = number
  description = "Timeout in seconds for the Grafana instance to be ready"
}

variable "monitoring_namespace" {
  type = string
}