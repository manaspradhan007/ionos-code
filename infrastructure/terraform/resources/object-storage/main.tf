resource "ionoscloud_s3_bucket" "example" {
  name                = var.name
  region              = var.region
  object_lock_enabled = var.object_lock
  force_destroy       = var.force_destroy
  tags                = var.tags
}