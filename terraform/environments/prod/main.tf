module "bucket" {
  source      = "../../modules/bucket"
  project_id  = var.project_id
  bucket_name = var.bucket_name
  region      = var.region
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