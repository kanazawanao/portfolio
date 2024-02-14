resource "google_compute_region_network_endpoint_group" "cloudrun_naz_web" {
  name                  = "cloudrun-naz-web-neg"
  network_endpoint_type = "SERVERLESS"
  region                = var.region
  cloud_run {
    service = var.cloud_run_service_name
  }
}

output "naz-web-network-endpoint-id" {
  value = google_compute_region_network_endpoint_group.cloudrun_naz_web.id
}