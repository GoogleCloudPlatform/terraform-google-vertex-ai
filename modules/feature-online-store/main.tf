/**
 * Copyright 2021 Google LLC
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

# Configure the Google Cloud provider
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create a Vertex AI Feature Online Store
# NOTE: Switched from the legacy 'google_vertex_ai_featurestore' to the
# newer 'google_vertex_ai_feature_online_store' to support Private Service Connect.
resource "google_vertex_ai_feature_online_store" "feature_online_store" {
  name   = var.featurestore_name
  labels = var.labels

  # Dynamically configure the storage type based on the 'storage_type' variable.
  # This allows choosing between 'optimized' and 'bigtable'.
  dynamic "optimized" {
    for_each = var.storage_type == "optimized" ? [1] : []
    content {}
  }

  dynamic "bigtable" {
    for_each = var.storage_type == "bigtable" ? [1] : []
    content {
      auto_scaling {
        min_node_count         = var.bigtable_min_node_count
        max_node_count         = var.bigtable_max_node_count
        cpu_utilization_target = var.bigtable_cpu_utilization_target
      }
    }
  }

  # Configuration for the dedicated serving endpoint, including Private Service Connect.
  dedicated_serving_endpoint {
    private_service_connect_config {
      enable_private_service_connect = var.enable_private_service_connect
      project_allowlist              = var.psc_project_allowlist
    }
  }

  # Setting force_destroy to true will delete the feature online store and all its
  # contents when you run `terraform destroy`.
  force_destroy = true

  # Configure timeouts for create, update, and delete operations.
  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}