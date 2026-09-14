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

resource "google_vertex_ai_semantic_governance_policy_engine" "policy_engine" {
  region          = var.region
  project         = var.project_id
  deletion_policy = var.deletion_policy

  dynamic "gateway_configs" {
    for_each = var.gateway_configs
    content {
      name             = gateway_configs.key
      network          = gateway_configs.value.network
      subnetwork       = gateway_configs.value.subnetwork
      dns_zone_name    = gateway_configs.value.dns_zone_name
      allowed_projects = gateway_configs.value.allowed_projects
    }
  }
}
