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

variable "region" {
  description = "The region of the SemanticGovernancePolicyEngine, e.g. 'us-central1'. Required by this module, even though the underlying resource treats region as optional."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which to create the SemanticGovernancePolicyEngine."
  type        = string
}

variable "deletion_policy" {
  description = "How Terraform treats destruction of the engine. One of DELETE (default; deprovision the engine), PREVENT (fail the destroy), or ABANDON (drop from state without deprovisioning)."
  type        = string
  default     = "DELETE"
  validation {
    condition     = contains(["DELETE", "PREVENT", "ABANDON"], var.deletion_policy)
    error_message = "deletion_policy must be one of DELETE, PREVENT, or ABANDON."
  }
}

variable "gateway_configs" {
  description = "Customer-VPC PSC gateway configurations, keyed by gateway name (at most 5). Each entry provisions a Private Service Connect endpoint. Within an entry, network, subnetwork, and dns_zone_name must all be set together or all omitted (a partial set is rejected); when set, network and subnetwork are full resource URIs and dns_zone_name is the private Cloud DNS zone the gateway's A-record is published into. allowed_projects (optional) enables decoupled mode and takes full 'projects/{id}' resource names."
  type = map(object({
    network          = optional(string)
    subnetwork       = optional(string)
    dns_zone_name    = optional(string)
    allowed_projects = optional(list(string))
  }))
  default  = {}
  nullable = false

  validation {
    condition     = length(var.gateway_configs) <= 5
    error_message = "At most 5 gateway_configs are allowed."
  }
}
