resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-sa"
  display_name = "Custom service account for GKE nodes"
}

resource "google_project_iam_member" "gke_node_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader",
    "roles/container.nodeServiceAccount" 
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  remove_default_node_pool = false  
  initial_node_count       = 2      
  deletion_protection      = false

  network    = var.network
  subnetwork = var.subnetwork

  node_config {
    machine_type    = "e2-medium"
    disk_type       = "pd-balanced"
    disk_size_gb    = 20
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true 
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = var.management_cidr
      display_name = "management subnet"
    }
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods"
    services_secondary_range_name = "services"
  }

  depends_on = [google_project_iam_member.gke_node_roles]
}
