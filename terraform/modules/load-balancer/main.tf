resource "google_compute_global_address" "default" {
  name = "${var.name}-address"
}

resource "google_compute_managed_ssl_certificate" "ssl" {
  name = "${var.name}-cert"
  managed {
    domains = [var.service_domain]
  }
}

resource "google_compute_ssl_policy" "tls12_modern" {
  name            = "static-ssl-policy"
  profile         = "MODERN"
  min_tls_version = "TLS_1_2"
}

resource "google_compute_backend_bucket" "cdn" {
  name        = "${var.name}-backet"
  bucket_name = var.bucket_name
  enable_cdn  = true
}

resource "google_compute_url_map" "static" {
  name            = "static-load-balancer"
  default_service = google_compute_backend_bucket.cdn.self_link
}

resource "google_compute_target_https_proxy" "static" {
  name             = "static-proxy"
  url_map          = google_compute_url_map.static.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.ssl.self_link]
  ssl_policy       = google_compute_ssl_policy.tls12_modern.id
}

resource "google_compute_global_forwarding_rule" "static" {
  name        = "static-forwarding-rule"
  target      = google_compute_target_https_proxy.static.self_link
  ip_protocol = "TCP"
  port_range  = "443"
  ip_address  = google_compute_global_address.default.address
}


output "load_balancer_ip" {
  value = google_compute_global_address.default.address
}
