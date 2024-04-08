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
  byod_bucket_location = "us-central1"
  byod_bucket_name     = "sin-222333-test-bucket"
  labels = {
    env  = "test"
    type = "workbench"
  }
}

module "common_vertex_ai_workbench" {
  source               = "../../modules/workbench/"
  name                 = "test-vertex-ai-instance"
  location             = local.location
  project_id           = var.project_id
  instance_owners      = var.instance_owners
  labels               = local.labels
  disable_proxy_access = true
  kms_key              = module.kms.keys["test"]

  machine_type         = "e2-standard-2"
  disable_public_ip    = true
  enable_ip_forwarding = false
  tags                 = ["abc", "def"]

  service_accounts = [
    {
      email = "${google_service_account.workbench_sa.email}"
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

  metadata = {
    post-startup-script          = "${module.gcs_buckets.url}/${google_storage_bucket_object.startup_script.name}"
    post-startup-script-behavior = "download_and_run_every_start"
  }

  bucket_prefix   = local.byod_bucket_name
  bucket_location = local.byod_bucket_location

  depends_on = [
    google_storage_bucket_iam_member.member,
    google_project_iam_member.sa_notebooks,
    google_project_iam_member.sa_aiplatform,
    google_project_iam_member.sa_compute_engine,
    google_storage_bucket_object.startup_script,
  ]
}
