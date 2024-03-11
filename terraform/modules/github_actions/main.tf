// Github Actionsの Secrets と variables 作成
data "github_repository" "web_repo" {
  full_name = var.web_repo_name
}

data "github_repository" "api_repo" {
  full_name = var.api_repo_name
}

resource "github_actions_secret" "web_identity_provider" {
  repository      = data.github_repository.web_repo.name
  secret_name     = "GCP_IDENTITY_PROVIDER"
  plaintext_value = var.gcp_identity_provider
}

resource "github_actions_secret" "web_service_account" {
  repository      = data.github_repository.web_repo.name
  secret_name     = "GCP_SERVICE_ACCOUNT"
  plaintext_value = var.gcp_service_account
}

resource "github_actions_variable" "web_cloud_run_name" {
  repository    = data.github_repository.web_repo.name
  variable_name = "GCS_CLOUD_RUN_NAME"
  value         = "naz-pg-web"
}

resource "github_actions_secret" "api_identity_provider" {
  repository      = data.github_repository.api_repo.name
  secret_name     = "GCP_IDENTITY_PROVIDER"
  plaintext_value = var.gcp_identity_provider
}

resource "github_actions_secret" "api_service_account" {
  repository      = data.github_repository.api_repo.name
  secret_name     = "GCP_SERVICE_ACCOUNT"
  plaintext_value = var.gcp_service_account
}

resource "github_actions_variable" "api_cloud_run_name" {
  repository    = data.github_repository.api_repo.name
  variable_name = "GCS_CLOUD_RUN_NAME"
  value         = "naz-pg-api"
}
