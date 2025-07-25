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

output "model_armor_template" {
  value       = module.model_armor_template.template
  description = "Template created"
}

output "location" {
  value       = module.model_armor_template.template.location
  description = "Location of the template created"
}

output "name" {
  value       = module.model_armor_template.template.name
  description = "Name of the template created"
}

output "template_id" {
  value       = module.model_armor_template.template.template_id
  description = "Template id of the template created"
}
