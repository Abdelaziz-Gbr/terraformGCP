module "my_network" {
  source          = "./network"
  project_id      = var.project_id
  region          = var.default_region
  zone            = var.default_zone
}

module "gke_cluster" {
  source     = "./GKE"
  project_id = var.project_id
  region     = var.default_region
  network    = module.my_network.network_full_name
  subnetwork = module.my_network.restricted_subnet
}

module "artifact_registry" {
  source      = "./docker-artifact-registry"
  project_id  = var.project_id
  region      = var.default_region
  repo_id     = "abdelaziz-gbr"
  description = "Docker Artifact Registry"
}












resource "kubernetes_namespace" "demo" {
  metadata {
    name = "demo"
  }
}
