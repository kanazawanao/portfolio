resource "random_id" "bucket_suffix" {
  byte_length = 8
}

resource "google_storage_bucket" "web_app" {
  location = var.region
  name = "${var.name}-${random_id.bucket_suffix.hex}"
  project = var.project_id
  force_destroy = true

  website {
    main_page_suffix = "index.html"
    not_found_page   = "index.html"
  }
}

resource "google_storage_bucket_access_control" "public_rule" {
  bucket = google_storage_bucket.web_app.id
  role = "READER"
  entity = "allUsers"
}

output "bucket_name" {
  value = google_storage_bucket.web_app.name
}