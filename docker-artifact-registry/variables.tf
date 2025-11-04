variable "region" {
    type        = string
    description = "The region to deploy the GKE cluster into."
}

variable "repo_id" {
    type        = string
    description = "The ID of the Artifact Registry repository."
}
variable "description" {
    type        = string
    description = "The description of the Artifact Registry repository."
}
variable "project_id" {
    type        = string
    description = "The ID of the GCP project to deploy resources into."
}