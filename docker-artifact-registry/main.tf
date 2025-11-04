# Create Artifact Registry Docker Repository
resource "google_artifact_registry_repository" "devops_repo" {
  provider      = google
  location      = var.region
  repository_id = var.repo_id
  description   = var.description
  format        = "DOCKER"

  docker_config {
    immutable_tags = false
  }

  labels = {
    environment = "dev"
    app         = "tornado"
  }
}


