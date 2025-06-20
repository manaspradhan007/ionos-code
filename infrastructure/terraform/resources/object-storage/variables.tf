variable "name" {
  description = "The name of the object storage bucket."
  type        = string
}

variable "region" {
  description = "The name of the object storage bucket."
  type        = string
}

variable "object_lock" {
  description = "The name of the object storage bucket."
  type        = bool

}
variable "force_destroy" {
  description = "allow/deny force destroy of bucket"
  type        = bool

}

variable "tags" {
  description = "tags"
  type        = map(string)
}
