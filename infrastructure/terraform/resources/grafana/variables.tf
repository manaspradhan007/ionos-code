variable "grafana_hostname" {
  type        = string
  description = "The hostname for the Grafana instance"   
}
variable "tags" {
  description = "tags"
  type        = map(string)
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