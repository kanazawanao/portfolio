terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "5.3.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = var.credentials
}


provider "github" {
  token = var.github_token
  owner = var.github_owner
}