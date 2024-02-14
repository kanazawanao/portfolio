data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service" "admin_console" {
  name     = "naz-pg"
  location = var.region

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [template]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.admin_console.location
  project  = google_cloud_run_service.admin_console.project
  service  = google_cloud_run_service.admin_console.name

  policy_data = data.google_iam_policy.noauth.policy_data

  depends_on = [data.google_iam_policy.noauth, google_cloud_run_service.admin_console]
}