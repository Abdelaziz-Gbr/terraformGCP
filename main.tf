module "my_network" {
  source          = "./network"
  project_id      = var.project_id
  region          = var.default_region
  zone            = var.default_zone
  management_cidr = var.management_cidr
  restricted_cidr = var.restricted_cidr
}

module "gke_cluster" {
  source     = "./GKE"
  project_id = var.project_id
  zone       = var.default_zone
  network    = module.my_network.network_full_name
  subnetwork = module.my_network.restricted_subnet
  management_cidr = var.management_cidr
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
  }

  tags = ["bastion"]

  metadata_startup_script = <<-EOT
    #!/bin/bash
    apt-get update -y
    apt-get install -y google-cloud-sdk kubectl
  EOT
}


module "artifact_registry" {
  source      = "./docker-artifact-registry"
  project_id  = var.project_id
  region      = var.default_region
  repo_id     = "abdelaziz-gbr"
  description = "Docker Artifact Registry"
}