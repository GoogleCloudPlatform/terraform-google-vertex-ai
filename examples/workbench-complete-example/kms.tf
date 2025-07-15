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

module "kms" {
  source          = "terraform-google-modules/kms/google"
  version         = "~> 3.0"
  project_id      = var.project_id
  location        = "us-central1"
  keyring         = "vertex-keyring-test-${random_id.suffix.hex}"
  keys            = ["test"]
  prevent_destroy = false
}

data "google_project" "project" {
  project_id = var.project_id
}

# https://cloud.google.com/vertex-ai/docs/workbench/instances/cmek#grant_permissions
# https://cloud.google.com/vertex-ai/docs/general/cmek#configure-cmek

resource "google_project_service_identity" "sa_notebooks" {
  provider = google-beta

  project = var.project_id
  service = "notebooks.googleapis.com"
}

resource "google_project_service_identity" "sa_aiplatform" {
  provider = google-beta

  project = var.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_kms_crypto_key_iam_member" "sa_notebooks" {
  crypto_key_id = module.kms.keys["test"]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.sa_notebooks.email}"
  # depends_on = [ google_project_iam_member.workbench_sa ]
}

resource "google_kms_crypto_key_iam_member" "sa_aiplatform" {
  crypto_key_id = module.kms.keys["test"]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_project_service_identity.sa_aiplatform.email}"
}

resource "google_kms_crypto_key_iam_member" "sa_compute_engine" {
  crypto_key_id = module.kms.keys["test"]
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}
