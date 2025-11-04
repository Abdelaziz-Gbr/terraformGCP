module "my_network" {
  source          = "./network"
  project_id      = var.project_id
  region          = var.default_region
  zone            = var.default_zone
  management_cidr = var.management_cidr
  restricted_cidr = var.restricted_cidr
}

module "gke_cluster" {
  source          = "./GKE"
  project_id      = var.project_id
  zone            = var.default_zone
  network         = module.my_network.network_full_name
  subnetwork      = module.my_network.restricted_subnet
  management_cidr = var.management_cidr
}

# Service account for bastion
resource "google_service_account" "bastion_sa" {
  account_id   = "sa-bastion"
  display_name = "Service account for bastion host"
}

# Grant bastion access to GKE
resource "google_project_iam_member" "bastion_gke_access" {
  project = var.project_id
  role    = "roles/container.developer"
  member  = "serviceAccount:${google_service_account.bastion_sa.email}"
}
resource "google_compute_instance" "bastion" {
  name         = "management-bastion"
  machine_type = "e2-micro"
  zone         = var.default_zone

  boot_disk {
    initialize_params {
      image = "projects/debian-cloud/global/images/family/debian-12"
    }
  }

  network_interface {
    subnetwork = module.my_network.management_subnet
    
    # Public IP for SSH access
    access_config {
      // Ephemeral public IP
    }
  }

  # Service account for accessing GKE
  service_account {
    email  = google_service_account.bastion_sa.email
    scopes = ["cloud-platform"]
  }

  tags = ["bastion"]

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin kubectl
    
    # Configure kubectl to use gke-gcloud-auth-plugin
    echo 'export USE_GKE_GCLOUD_AUTH_PLUGIN=True' >> /etc/profile.d/gke-auth.sh
  EOT
}



# Firewall for IAP SSH
resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = module.my_network.network_full_name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["35.235.240.0/20"]
  target_tags   = ["bastion"]
  direction     = "INGRESS"
}

module "artifact_registry" {
  source      = "./docker-artifact-registry"
  project_id  = var.project_id
  region      = var.default_region
  repo_id     = "abdelaziz-gbr"
  description = "Docker Artifact Registry"
}