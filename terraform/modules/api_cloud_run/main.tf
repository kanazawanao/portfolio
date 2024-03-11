data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service" "naz_pg_api" {
  name     = "naz-pg-api"
  location = var.region

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  metadata {
    annotations = {
      // https://cloud.google.com/sdk/gcloud/reference/run/deploy#--ingress
      "run.googleapis.com/ingress" = "internal-and-cloud-load-balancing"
    }
  }

  autogenerate_revision_name = true

  lifecycle {
    ignore_changes = [template]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location = google_cloud_run_service.naz_pg_api.location
  project  = google_cloud_run_service.naz_pg_api.project
  service  = google_cloud_run_service.naz_pg_api.name

  policy_data = data.google_iam_policy.noauth.policy_data

  depends_on = [data.google_iam_policy.noauth, google_cloud_run_service.naz_pg_api]
}

output "cloud_run_service_name" {
  value = google_cloud_run_service.naz_pg_api.name
}