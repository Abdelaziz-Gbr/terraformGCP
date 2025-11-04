variable "project_id" {
    type        = string
    description = "The ID of the GCP project to deploy resources into."
}

variable "region" {
    type        = string
    description = "The region for GCP resources."
}

variable "zone" {
    type        = string
    description = "The zone for GCP resources."
}

variable "management_cidr" {
  type        = string
  description = "The CIDR block for management network allowed to access GKE master."
}

variable "restricted_cidr" {
  type        = string
  description = "The CIDR block for restricted network allowed to access GKE master."
}