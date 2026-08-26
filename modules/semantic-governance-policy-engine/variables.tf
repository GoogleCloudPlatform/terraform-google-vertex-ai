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
