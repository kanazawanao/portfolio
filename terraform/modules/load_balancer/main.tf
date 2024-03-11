resource "google_compute_global_address" "default" {
  name = "${var.name}-address"
}

resource "google_compute_managed_ssl_certificate" "naz_ssl" {
  name = "${var.name}-naz-cert"
  managed {
    domains = [var.service_domain, "api.${var.service_domain}"]
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

resource "google_compute_backend_service" "web-naz" {
  name = "web-naz-backend"

  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30

  backend {
    group = var.web_network_endpoint_id
  }
}

resource "google_compute_backend_service" "api-naz" {
  name = "api-naz-backend"

  protocol        = "HTTP"
  port_name       = "http"
  timeout_sec     = 30
  security_policy = var.security_policy_id

  backend {
    group = var.api_network_endpoint_id
  }
}


resource "google_compute_url_map" "static" {
  name            = "static-load-balancer"
  default_service = google_compute_backend_service.web-naz.self_link

  host_rule {
    hosts        = [var.service_domain]
    path_matcher = "naz-pg"
  }

  host_rule {
    hosts        = ["api.${var.service_domain}"]
    path_matcher = "api"
  }

  path_matcher {
    name            = "naz-pg"
    default_service = google_compute_backend_service.web-naz.self_link
  }

  path_matcher {
    name            = "api"
    default_service = google_compute_backend_service.api-naz.self_link
  }
}

resource "google_compute_target_https_proxy" "static" {
  name             = "static-proxy"
  url_map          = google_compute_url_map.static.self_link
  ssl_certificates = [google_compute_managed_ssl_certificate.naz_ssl.self_link]
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
