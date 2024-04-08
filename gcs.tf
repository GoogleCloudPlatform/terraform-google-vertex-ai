/**
 * Copyright 2023 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  # startup_script_template = "gcs_fuse.sh.tpl"
  # startup_script_name     = "startup_script.sh"
}

module "byod_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name          = var.bucket_prefix
  storage_class = var.bucket_storage_class
  versioning    = var.bucket_versioning
  project_id    = var.project_id
  location      = var.bucket_location
  # iam_members = var.service_accounts == null ? [] : [{
  #   role   = "roles/storage.admin"
  #   member = "serviceAccount:${var.service_account}"
  # }]

  force_destroy = true
}
resource "google_storage_bucket_iam_member" "member_sa" {
  for_each = toset(["roles/storage.admin", "roles/storage.objectAdmin"])
  bucket   = module.byod_bucket.name
  role     = each.value
  member   = "serviceAccount:${var.service_accounts[0].email}"
}

resource "google_storage_bucket_iam_member" "member_access_group" {
  for_each = var.byod_access_group == null ? [] : toset(["roles/storage.admin", "roles/storage.objectAdmin"])
  bucket   = module.byod_bucket.name
  role     = each.value
  member   = "group:${var.byod_access_group}"

  dynamic "condition" {
    for_each = var.bucket_timestamp == null ? [] : ["condition"]
    content {
      title       = "expires_after_${var.bucket_timestamp}"
      description = "Expiring at ${var.bucket_timestamp}"
      expression  = "request.time < timestamp(\"${var.bucket_timestamp}\")"
    }
  }
}
