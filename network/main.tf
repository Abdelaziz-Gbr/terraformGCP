module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "12.0.0"

  project_id   = var.project_id
  network_name = "iti-vpc-network"
  auto_create_subnetworks = false

  subnets = [
    {
      subnet_name   = "management-subnet"
      subnet_ip     = "10.0.0.0/24"
      subnet_region = var.default_region
    },
    {
      subnet_name   = "restricted-subnet"
      subnet_ip     = "10.0.1.0/24"
      subnet_region = var.default_region
    }
  ]
}

resource "google_compute_router" "nat_router" {
  name    = "nat-router"
  region  = var.default_region
  network = module.vpc.network_name
  depends_on = [module.vpc]
}

resource "google_compute_router_nat" "nat_config" {
  name   = "nat-config"
  router = google_compute_router.nat_router.name
  region = google_compute_router.nat_router.region
  depends_on = [module.vpc]
  nat_ip_allocate_option = "AUTO_ONLY"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  subnetwork {
    name                    = "projects/${var.project_id}/regions/${var.default_region}/subnetworks/restricted-subnet"
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
