resource "google_dns_managed_zone" "default" {
  name        = "${var.name}-zone"
  dns_name    = "${var.service_domain}."
  description = "Web app DNS zone"
}

resource "google_dns_record_set" "default" {
  name         = google_dns_managed_zone.default.dns_name
  managed_zone = google_dns_managed_zone.default.name
  type         = "A"
  ttl          = 300
  rrdatas = [
    var.web_app_load_balancer_ip
  ]
}

resource "google_dns_record_set" "cname_api" {
  name         = "api.${google_dns_managed_zone.default.dns_name}"
  managed_zone = google_dns_managed_zone.default.name
  type         = "CNAME"
  ttl          = 300
  rrdatas = [
    google_dns_managed_zone.default.dns_name
  ]
}
