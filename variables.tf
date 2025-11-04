variable "project_id" {
    type        = string
    description = "The ID of the GCP project to deploy resources into."
}

variable "default_region" {
    type        = string
    description = "The default region for GCP resources."
}

variable "default_zone" {
    type        = string
    description = "The default zone for GCP resources."
}

variable "private_subnet_name" {
    type        = string
    description = "The name of the private subnet."
    default     = "restricted-subnet"
}