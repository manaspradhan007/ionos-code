variable "name" {
  description = "The name of the object storage bucket."
  type        = string
}

variable "region" {
  description = "The name of the object storage bucket."
  type        = string
  default     = "eu-central-3"
}

variable "object_lock" {
  description = "The name of the object storage bucket."
  type        = bool
  default     = false
}
variable "force_destroy" {
  description = "allow/deny force destroy of bucket"
  type        = bool
  default     = false
}

variable "tags" {
  description = "tags"
  type        = map(string)
}