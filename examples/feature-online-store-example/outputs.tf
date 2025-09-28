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

output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "region" {
  value       = var.region
  description = "The region"
}

output "feature_online_store_id" {
  description = "The full resource ID of the created Vertex AI Feature Online Store."
  value       = module.feature_online_store.feature_online_store_id
}

output "feature_online_store_name_output" {
  description = "The name of the created Vertex AI Feature Online Store."
  value       = module.feature_online_store.feature_online_store_name_output
}

output "psc_service_attachment" {
  description = "The service attachment URI for the Private Service Connect endpoint."
  value       = module.feature_online_store.psc_service_attachment
}
