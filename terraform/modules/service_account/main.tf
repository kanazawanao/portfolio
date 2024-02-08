//GCP サービスアカウントの作成
resource "google_service_account" "github_actions_sa" {
  account_id   = "github-actions-sa"
  display_name = "Github Actions"
  description  = "GitHub ActionsのWorkload Identity Federationにのみ使用できるサービスアカウントです。"
  disabled     = false
}

output "service_account_email" {
  value = google_service_account.github_actions_sa.email
}

resource "google_service_account_iam_policy" "policy" {
  policy_data        = data.google_iam_policy.policy.policy_data
  service_account_id = google_service_account.github_actions_sa.name
}

data "google_iam_policy" "policy" {
  binding {
    members = [
      "principalSet://iam.googleapis.com/${var.identity_pool_name}/attribute.repository/${var.repo_name}",
    ]
    role = "roles/iam.workloadIdentityUser"
  }
}

resource "google_project_iam_member" "github_actions_iam" {
  project = var.project_id
  role    = "roles/storage.admin"

  member = "serviceAccount:${google_service_account.github_actions_sa.email}"
}
