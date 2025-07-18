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

module "project" {
  source                  = "terraform-google-modules/project-factory/google"
  version                 = "~> 18.0"
  name                    = "ci-vertex-ai"
  random_project_id       = "true"
  org_id                  = var.org_id
  folder_id               = var.folder_id
  billing_account         = var.billing_account
  default_service_account = "keep"
  deletion_policy         = "DELETE"

  activate_apis = [
    "cloudresourcemanager.googleapis.com",
    "serviceusage.googleapis.com",
    "iamcredentials.googleapis.com",
    "iam.googleapis.com",
    "cloudbilling.googleapis.com",
    "cloudkms.googleapis.com",
    "servicenetworking.googleapis.com",
    "secretmanager.googleapis.com",
    "notebooks.googleapis.com",
    "aiplatform.googleapis.com",
    "iap.googleapis.com",
    "modelarmor.googleapis.com",
    "dlp.googleapis.com",
  ]

  disable_dependent_services  = false
  disable_services_on_destroy = false
}
