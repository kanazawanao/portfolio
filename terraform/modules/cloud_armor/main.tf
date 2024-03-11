resource "google_compute_security_policy" "default" {
  name    = "${var.name}-sequrity-policy"
  project = var.project_id

  # OWASP TOP10 Risk ※割り当てが５つまでなので分割しています。
  rule {
    action      = "deny(403)"
    description = "OWASP TOP10 Risk (1)"
    preview     = false
    priority    = 1000

    match {
      expr {
        expression = <<-EOT
                        evaluatePreconfiguredExpr("sqli-v33-stable")
                        || evaluatePreconfiguredExpr("xss-v33-stable")
                        || evaluatePreconfiguredExpr("lfi-v33-stable")
                        || evaluatePreconfiguredExpr("rfi-v33-stable")
                        || evaluatePreconfiguredExpr("rce-v33-stable")
        EOT
      }
    }
  }

  rule {
    action      = "deny(403)"
    description = "OWASP TOP10 Risk (2)"
    preview     = false
    priority    = 1100

    match {
      expr {
        expression = <<-EOT
                        evaluatePreconfiguredExpr("protocolattack-v33-stable")
                        || evaluatePreconfiguredExpr("sessionfixation-v33-stable")
        EOT
      }
    }
  }

  # Default
  rule {
    action      = "allow"
    description = "default rule"
    preview     = false
    priority    = 2147483647

    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}

output "security_policy_id" {
  value = google_compute_security_policy.default.id
}
