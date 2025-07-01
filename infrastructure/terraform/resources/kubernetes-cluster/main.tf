resource "ionoscloud_datacenter" "testdatacenter" {
  name                    = var.datacenter_name
  location                = var.location
  description             = "Test datacenter"
}

resource "ionoscloud_ipblock" "k8sip" {
  location = "de/fra"
  size = 1
  name = "IP Block Private K8s"
}

resource "ionoscloud_k8s_cluster" "k8s_cluster" {
  name                  = var.managed_cluster_name
  k8s_version           = var.k8s_version
  api_subnet_allow_list = ["178.25.194.45/32"]
  s3_buckets {
     name               = "k8s-managed-cluster-${var.region}-s3-bucket"
  }
  nat_gateway_ip = ionoscloud_ipblock.k8sip.ips[0]
  node_subnet = "192.168.0.0/16"
}

resource "ionoscloud_k8s_node_pool" "nodepool" {
  datacenter_id         = ionoscloud_datacenter.testdatacenter.id
  k8s_cluster_id        = ionoscloud_k8s_cluster.k8s_cluster.id
  name                  = "np-01"
  k8s_version           = ionoscloud_k8s_cluster.k8s_cluster.k8s_version
  maintenance_window {
    day_of_the_week     = "Saturday"
    time                = "09:00:00Z"
  } 
  auto_scaling {
    min_node_count      = 4
    max_node_count      = 5
  }
  cpu_family            = "INTEL_XEON"
  availability_zone     = "AUTO"
  storage_type          = "SSD"
  node_count            = 3
  cores_count           = 2
  ram_size              = 2048
  storage_size          = 20
  server_type           = "DedicatedCore"
  public_ips            = [ ionoscloud_ipblock.k8sip.ips[0] ]
}