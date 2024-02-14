module "bucket" {
  source     = "../../modules/bucket"
  project_id = var.project_id
  name       = var.name
  region     = var.region
}

module "identity_pool" {
  source       = "../../modules/identity_pool"
  github_owner = var.github_owner
  github_token = var.github_token
  repo_name    = var.repo_name
  bucket_name  = module.bucket.bucket_name
  project_id   = var.project_id
}

module "service_account" {
  source             = "../../modules/service_account"
  repo_name          = var.repo_name
  identity_pool_name = module.identity_pool.workload_identity_pool_name
  project_id         = var.project_id
  bucket_name        = module.bucket.bucket_name
}

module "github_actions" {
  source                = "../../modules/github_actions"
  bucket_name           = module.bucket.bucket_name
  github_owner          = var.github_owner
  github_token          = var.github_token
  repo_name             = var.repo_name
  gcp_identity_provider = module.identity_pool.workload_identity_pool_provider_name
  gcp_service_account   = module.service_account.service_account_email
}

module "cloud_run" {
  source = "../../modules/cloud_run"
  region = var.region
}

module "network" {
  source = "../../modules/network"
  region = var.region
  cloud_run_service_name = module.cloud_run.cloud_run_service_name
}

module "load_balancer" {
  source         = "../../modules/load_balancer"
  bucket_name    = module.bucket.bucket_name
  name           = var.name
  service_domain = var.service_domain
  web_admin_console_network_endpoint_id = module.network.naz-web-network-endpoint-id
}

module "routing" {
  source                   = "../../modules/routing"
  name                     = var.name
  web_app_load_balancer_ip = module.load_balancer.load_balancer_ip
  service_domain           = var.service_domain
}