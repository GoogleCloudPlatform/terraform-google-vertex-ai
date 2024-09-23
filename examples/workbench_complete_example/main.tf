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
  location             = "us-central1-a"
  bucket_location      = "us-central1"
  byod_bucket_name     = "byod-test-bucket-${random_id.suffix.hex}"
  metadata_bucket_name = "metadata-bucket"
  labels = {
    env  = "test"
    type = "workbench"
  }
}

resource "google_service_account" "workbench_sa" {
  account_id   = "vertex-ai-workbench-sa"
  display_name = "Vertex AI Workbench Service Account"
  project      = var.project_id
}

module "complete_vertex_ai_workbench" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/workbench"
  version = "~> 0.2"

  name                 = "complete-vertex-ai-workbench"
  location             = local.location
  project_id           = var.project_id
  labels               = local.labels
  disable_proxy_access = true

  kms_key         = module.kms.keys["test"]
  disk_encryption = "CMEK"

  machine_type         = "e2-standard-2"
  disable_public_ip    = true
  enable_ip_forwarding = false
  tags                 = ["abc", "def"]

  instance_owners = var.instance_owners

  service_accounts = [
    {
      email = google_service_account.workbench_sa.email
    },
  ]

  data_disks = [
    {
      disk_size_gb = 330
      disk_type    = "PD_BALANCED"
    },
  ]

  network_interfaces = [
    {
      network  = module.test-vpc-module.network_id
      subnet   = module.test-vpc-module.subnets_ids[0]
      nic_type = "GVNIC"
    }
  ]

  ## https://cloud.google.com/vertex-ai/docs/workbench/instances/manage-metadata
  metadata_configs = {
    post-startup-script          = "${module.metadata_gcs_bucket.url}/${google_storage_bucket_object.startup_script.name}"
    post-startup-script-behavior = "download_and_run_every_start"
    idle-timeout-seconds         = 3600
    notebook-disable-root        = true
    notebook-upgrade-schedule    = "00 19 * * SAT"
  }

  shielded_instance_config = {
    enable_secure_boot = true
  }

  depends_on = [
    google_storage_bucket_iam_member.member,
    google_kms_crypto_key_iam_member.sa_notebooks,
    google_kms_crypto_key_iam_member.sa_aiplatform,
    google_kms_crypto_key_iam_member.sa_compute_engine,
    google_storage_bucket_object.startup_script,
  ]
}
