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


resource "google_service_account" "workbench_sa" {
  account_id   = "vertex-ai-workbench-sa"
  display_name = "Vertex AI Workbench Service Account"
  project      = var.project_id
}

module "simple_vertex_ai_workbench" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/workbench"
  version = "~> 2.0"

  name       = "simple-vertex-ai-workbench"
  location   = "us-central1-a"
  project_id = var.project_id

  machine_type = "e2-standard-2"

  labels = {
    env  = "test"
    type = "workbench"
  }

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
}
