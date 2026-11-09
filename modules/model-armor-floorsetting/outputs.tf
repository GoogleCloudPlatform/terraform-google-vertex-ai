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

output "floorsetting" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting
  description = "Model armor floor setting created"
}

output "id" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting.id
  description = "An identifier for the Model Armor floor setting resource."
}

output "name" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting.name
  description = "The resource name of the Model Armor floor setting."
}

output "parent" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting.parent
  description = "The parent resource path (projects/{project}, folders/{folder}, or organizations/{organizationId})."
}

output "create_time" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting.create_time
  description = "Timestamp when the Model Armor floor setting was created."
}

output "update_time" {
  value       = google_model_armor_floorsetting.model_armor_floorsetting.update_time
  description = "Timestamp when the Model Armor floor setting was last updated."
}
