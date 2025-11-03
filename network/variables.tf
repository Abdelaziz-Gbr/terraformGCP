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