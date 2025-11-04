resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.region

  remove_default_node_pool = false
  initial_node_count       = 2
  deletion_protection = false
  node_config {
    machine_type = "e2-micro"
    disk_type    = "pd-balanced"
    disk_size_gb = 15
  }

  network    = var.network
  subnetwork = var.subnetwork

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "10.10.1.0/24"
      display_name = "Restricted subnet"
    }
    cidr_blocks{
      cidr_block   = "102.45.189.145/32"
      display_name = "my laptop"
    }
  }
}