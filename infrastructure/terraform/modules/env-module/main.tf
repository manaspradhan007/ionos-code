module "storage" {
  source        = "../../resources/object_storage"
  name          = var.name
  region        = var.region
  object_lock   = var.object_lock
  force_destroy = var.force_destroy
  tags          = var.tags
}