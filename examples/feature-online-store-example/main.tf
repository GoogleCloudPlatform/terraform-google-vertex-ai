/**
 * Copyright 2025 Google LLC
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

resource "random_id" "suffix" {
  byte_length = 4
}

module "feature_online_store" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/feature-online-store"
  
  project_id        = var.project_id
  featurestore_name = "example_featurestore_name_${random_id.suffix.hex}"
  region            = "us-central1"

  labels = {}

  storage_type                    = "optimized"
  bigtable_min_node_count         = 1
  bigtable_max_node_count         = 5
  bigtable_cpu_utilization_target = 50

  create_timeout = "30m"
  update_timeout = "30m"
  delete_timeout = "30m"

  enable_private_service_connect = true
  psc_project_allowlist          = []
}
