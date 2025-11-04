output "repository_url" {
  value = "LOCATION-docker.pkg.dev/${var.project_id}/${google_artifact_registry_repository.devops_repo.repository_id}"
}