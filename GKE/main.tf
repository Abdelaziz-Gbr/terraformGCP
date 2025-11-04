resource "google_service_account" "gke_nodes" {
  account_id   = "gke-node-sa"
  display_name = "Custom service account for GKE nodes"
}

resource "google_project_iam_member" "gke_node_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/artifactregistry.reader"
  ])

  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.gke_nodes.email}"
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = var.zone

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false

  network    = var.network
  subnetwork = var.subnetwork
  node_config {
    machine_type    = "e2-micro"
    disk_type       = "pd-balanced"
    disk_size_gb    = 15
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
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
      cidr_block   = var.management_cidr
      display_name = "management subnet"
    }
  }
}

resource "google_container_node_pool" "primary_nodes" {
  name       = "primary-node-pool"
  cluster    = google_container_cluster.primary.self_link
  location   = var.zone
  node_count = 2

  node_config {
    machine_type    = "e2-medium"
    disk_type       = "pd-balanced"
    disk_size_gb    = 20
    service_account = google_service_account.gke_nodes.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

}