terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.9.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.default_region
  zone    = var.default_zone
}

module "my_network" {
  source          = "./network"
  project_id      = var.project_id
  default_region  = var.default_region
  default_zone    = var.default_zone
}
