module "byod_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name          = local.byod_bucket_name
  project_id    = var.project_id
  location      = local.bucket_location
  force_destroy = true
}


resource "google_storage_bucket_iam_member" "member_sa" {
  for_each = toset(["roles/storage.admin", "roles/storage.objectAdmin"])
  bucket   = module.byod_bucket.name
  role     = each.value
  member   = "serviceAccount:${google_service_account.workbench_sa.email}"
}
