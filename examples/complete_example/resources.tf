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

resource "random_id" "bucket_suffix" {
  byte_length = 4
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 8.0"
  project_id   = var.project_id
  network_name = "test-net"
  mtu          = 1460
  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
  ]
  ingress_rules = [
    {
      name          = "allow-ssh-from-iap"
      description   = "Allow all traffic from IAP"
      ranges        = null
      source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    },
  ]
}

module "kms" {
  source          = "terraform-google-modules/kms/google"
  version         = "~> 2.2"
  project_id      = var.project_id
  location        = "us-central1"
  keyring         = "vertex-keyring-test-${random_id.bucket_suffix.hex}"
  keys            = ["test"]
  prevent_destroy = false
}

# IAM Grants
resource "google_service_account" "workbench_sa" {
  account_id   = "vertex-ai-workbench-sa"
  display_name = "Vertex AI Workbench Service Account"
  project      = var.project_id
}

# resource "google_project_iam_member" "workbench_sa_roles_grant" {
#   project = var.project_id
#   role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
#   member  = "serviceAccount:${google_service_account.workbench_sa.email}"
# }

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

resource "google_project_iam_member" "sa_notebooks" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_project_service_identity.sa_notebooks.email}"
}


resource "google_project_service_identity" "sa_aiplatform" {
  provider = google-beta

  project = var.project_id
  service = "aiplatform.googleapis.com"
}

resource "google_project_iam_member" "sa_aiplatform" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:${google_project_service_identity.sa_aiplatform.email}"
}

resource "google_project_iam_member" "sa_compute_engine" {
  project = var.project_id
  role    = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member  = "serviceAccount:service-${data.google_project.project.number}@compute-system.iam.gserviceaccount.com"
}

### This assigns permission on vertex AI workbench instance. Cant assign permission on the physical VM behind the scene.

# resource "google_workbench_instance_iam_member" "member" {
#   project = module.complete_vertex_ai_workbench.work_bench.project
#   location = module.complete_vertex_ai_workbench.work_bench.location
#   name = module.complete_vertex_ai_workbench.work_bench.name
#   role = "roles/viewer"
#   member = "user:imrannayer@gmail.com"
# }

# ##############################   IAP/OsLogin Project Level Permissions   ##########################################################################################

# resource "google_project_iam_member" "instance_owner_roles_grant" {
#   for_each = toset([
#     "roles/compute.osLogin",            ### Need this permission at project level as it also grants compute.projects.get which is needed at project level.
#     "roles/iap.tunnelResourceAccessor", # Need this for IAP
#     "roles/iam.serviceAccountUser",     # Need this to create tunnel to the VM
#   ])
#   project = var.project_id
#   role    = each.value
#   member  = "user:${var.instance_owner}"
# }



# ##############################   IAP/OsLogin VM Level Permissions   ##########################################################################################

# ## OS Login Role at VM level. Will need compute.projects.get permission on project

resource "google_compute_instance_iam_member" "vm_os_login" {
  for_each = tolist(var.instance_owners)
  project       = module.complete_vertex_ai_workbench.work_bench.project
  zone          = module.complete_vertex_ai_workbench.work_bench.location
  instance_name = module.complete_vertex_ai_workbench.work_bench.name
  role          = "roles/compute.osLogin"
  member        = "user:${each.value}"
}

# IAP Tunnel Role at VM level

resource "google_iap_tunnel_instance_iam_member" "vm_iap_tunnel_user" {
  for_each = tolist(var.instance_owners)
  project  = module.complete_vertex_ai_workbench.work_bench.project
  zone     = module.complete_vertex_ai_workbench.work_bench.location
  instance = module.complete_vertex_ai_workbench.work_bench.name
  role     = "roles/iap.tunnelResourceAccessor"
  member        = "user:${each.value}"
}

resource "google_project_iam_custom_role" "os_login_custom_role" {
  project     = var.project_id
  role_id     = "osLoginCustomRole${random_id.bucket_suffix.hex}"
  title       = "Os Login prj level Custom Role"
  description = "Custom Project level role for os login"
  permissions = [
    "compute.projects.get",
  ]
}

resource "google_project_iam_member" "os_login_custom_role" {
  for_each = tolist(var.instance_owners)
  project = var.project_id
  role    = google_project_iam_custom_role.os_login_custom_role.name
  member        = "user:${each.value}"
}

resource "google_service_account_iam_member" "instance_owner_sa_role" {
  for_each = tolist(var.instance_owners)
  service_account_id = google_service_account.workbench_sa.name
  role               = "roles/iam.serviceAccountUser"
  member        = "user:${each.value}"
}
