// Github Actionsの Secrets と variables 作成
data "github_repository" "repo" {
  full_name = var.repo_name
}

resource "github_actions_secret" "identity_provider" {
  repository      = data.github_repository.repo.name
  secret_name     = "GCP_IDENTITY_PROVIDER"
  plaintext_value = var.gcp_identity_provider
}

resource "github_actions_secret" "service_account" {
  repository      = data.github_repository.repo.name
  secret_name     = "GCP_SERVICE_ACCOUNT"
  plaintext_value = var.gcp_service_account
}

resource "github_actions_variable" "bucket_name" {
  repository    = data.github_repository.repo.name
  variable_name = "GCS_BUCKET_NAME"
  value         = var.bucket_name
}