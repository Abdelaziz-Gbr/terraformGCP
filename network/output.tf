output "network_full_name" {
  value = google_compute_network.vpc.self_link
}

output "management_subnet" {
  value = google_compute_subnetwork.management-subnet.self_link
}

output "restricted_subnet" {
  value = google_compute_subnetwork.restricted-subnet.self_link
}