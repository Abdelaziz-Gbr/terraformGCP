variable "network" {
    type        = string
    description = "The name of the VPC network to deploy GKE cluster into."
}

variable "subnetwork" {
    type        = string
    description = "The name of the subnetwork to deploy GKE cluster into."
}
variable "zone" {
    type        = string
    description = "The zone to deploy the GKE cluster into."
}
variable "project_id" {
    type        = string
    description = "The ID of the GCP project to deploy resources into."
}

variable "management_cidr" {
  type        = string
  description = "The CIDR block for management network allowed to access GKE master."
}