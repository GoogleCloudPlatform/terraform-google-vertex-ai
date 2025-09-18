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

variable "project_id" {
  description = "The ID of the Google Cloud project."
  type        = string
}

variable "region" {
  description = "The region where the Vertex AI Feature Online Store will be created."
  type        = string
  default     = "us-central1"
}

variable "featurestore_name" {
  description = "The name of the Vertex AI Feature Online Store."
  type        = string
  default     = "my_online_featurestore"
}

variable "labels" {
  description = "A map of labels to assign to the feature online store."
  type        = map(string)
  default     = {}
}

# --- New variables for Storage, Scaling, and Embeddings ---

variable "storage_type" {
  description = "The storage type for the feature online store. Must be either 'optimized' or 'bigtable'."
  type        = string
  default     = "optimized"
  validation {
    condition     = contains(["optimized", "bigtable"], var.storage_type)
    error_message = "The storage_type must be either 'optimized' or 'bigtable'."
  }
}

variable "bigtable_min_node_count" {
  description = "The minimum number of nodes for Bigtable autoscaling."
  type        = number
  default     = 1
}

variable "bigtable_max_node_count" {
  description = "The maximum number of nodes for Bigtable autoscaling."
  type        = number
  default     = 5
}

variable "bigtable_cpu_utilization_target" {
  description = "The target CPU utilization percentage for Bigtable autoscaling."
  type        = number
  default     = 50
}

# --- New variables for Timeouts ---

variable "create_timeout" {
  description = "The timeout for creating the Feature Online Store."
  type        = string
  default     = "30m"
}

variable "update_timeout" {
  description = "The timeout for updating the Feature Online Store."
  type        = string
  default     = "30m"
}

variable "delete_timeout" {
  description = "The timeout for deleting the Feature Online Store."
  type        = string
  default     = "30m"
}


# --- Variables for Private Service Connect ---

variable "enable_private_service_connect" {
  description = "Set to true to enable Private Service Connect."
  type        = bool
  default     = true
}

variable "psc_project_allowlist" {
  description = "A list of project IDs from which to allow Private Service Connect connections."
  type        = list(string)
  default     = [] # e.g., ["my-consumer-project-12345"]
}
