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

output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "location" {
  value       = local.location
  description = "The location of the Vertex AI Workbench instance"
}

output "workbench_name" {
  value       = module.complete_vertex_ai_workbench.workbench_name
  description = "The name of the Vertex AI Workbench instance"
}

output "workbench" {
  value       = module.complete_vertex_ai_workbench
  description = "The Vertex AI Workbench instance"
}

output "kms_key" {
  value       = module.kms.keys["test"]
  description = "The KMS key for Vertex AI Workbench instance"
}

output "service_account" {
  value       = google_service_account.workbench_sa.email
  description = "The service account for Vertex AI Workbench instance"
}

output "network" {
  value       = module.test-vpc-module.network_self_link
  description = "The network for Vertex AI Workbench instance"
}

output "subnet" {
  value       = module.test-vpc-module.subnets_self_links[0]
  description = "The subnet for Vertex AI Workbench instance"
}
