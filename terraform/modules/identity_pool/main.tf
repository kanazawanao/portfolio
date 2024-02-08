resource "random_integer" "suffix" {
  min = 1000
  max = 9999
}

// GCP Workload Identity連携の作成
resource "google_iam_workload_identity_pool" "github_actions_pool" {
  project                   = var.project_id
  workload_identity_pool_id = "github-pool-${random_integer.suffix.id}"
  display_name              = "github-pool"
  description               = "GitHub Actionsで使用"
}

output "workload_identity_pool_name" {
  value = google_iam_workload_identity_pool.github_actions_pool.name
}

resource "google_iam_workload_identity_pool_provider" "github_actions" {
  project                            = var.project_id
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_actions_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-actions"
  display_name                       = "github-actions"
  disabled                           = false
  description                        = "GitHub Actionsで使用"
  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.actor"      = "assertion.actor",
    "attribute.repository" = "assertion.repository"
  }
}

output "workload_identity_pool_provider_name" {
  value = google_iam_workload_identity_pool_provider.github_actions.name
}
