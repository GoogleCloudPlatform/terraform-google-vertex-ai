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

output "id" {
  value       = module.semantic_governance_policy_engine.policy_engine.id
  description = "The engine identifier"
}

output "state" {
  value       = module.semantic_governance_policy_engine.policy_engine.state
  description = "The current state of the engine"
}

output "psc_service_attachment" {
  value       = module.semantic_governance_policy_engine.policy_engine.psc_service_attachment
  description = "The Private Service Connect service attachment URI for the engine's managed endpoint"
}
