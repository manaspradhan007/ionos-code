resource "ionoscloud_container_registry" "cr" {
  garbage_collection_schedule {
    days                = ["Monday", "Tuesday"]
    time                = "05:19:00+00:00"
  }
  location              = "de/fra"
  name                  = "task-container-registry"
  api_subnet_allow_list = var.api_subnet_allow_list
}