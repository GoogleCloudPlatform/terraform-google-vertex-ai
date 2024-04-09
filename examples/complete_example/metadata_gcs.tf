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
  startup_script_template = "gcs_fuse.sh.tpl"
  startup_script_name     = "startup_script.sh"
}

module "metadata_gcs_bucket" {
  source  = "terraform-google-modules/cloud-storage/google//modules/simple_bucket"
  version = "~> 5.0"

  name          = "${local.metadata_bucket_name}-${random_id.suffix.hex}"
  project_id    = var.project_id
  location      = local.bucket_location
  force_destroy = true
}

resource "google_storage_bucket_iam_member" "member" {
  bucket = module.metadata_gcs_bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.workbench_sa.email}"
}


# Render startup script
data "template_file" "startup_script" {
  template = file(format("%s/${local.startup_script_template}", path.module))

  vars = {
    gcs_bucket = local.byod_bucket_name
  }
}

# upload startup script to metadata bucket
resource "google_storage_bucket_object" "startup_script" {
  name    = local.startup_script_name
  content = data.template_file.startup_script.rendered
  bucket  = module.metadata_gcs_bucket.name
}

output "gcs_bucket_url" {
  value = module.metadata_gcs_bucket.url
}
