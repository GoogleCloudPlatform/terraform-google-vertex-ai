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

module "byod_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 6.0"

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
