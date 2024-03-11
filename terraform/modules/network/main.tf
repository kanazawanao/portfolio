resource "google_compute_region_network_endpoint_group" "cloudrun_naz_web" {
  name                  = "cloudrun-naz-web-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.web_cloud_run_service_name
  }
}

output "naz-web-network-endpoint-id" {
  value = google_compute_region_network_endpoint_group.cloudrun_naz_web.id
}

resource "google_compute_region_network_endpoint_group" "cloudrun_naz_api" {
  name                  = "cloudrun-naz-api-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.api_cloud_run_service_name
  }
}

output "naz-api-network-endpoint-id" {
  value = google_compute_region_network_endpoint_group.cloudrun_naz_api.id
}