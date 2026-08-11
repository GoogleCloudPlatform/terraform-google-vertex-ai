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

output "policy_engine" {
  description = "The full google_vertex_ai_semantic_governance_policy_engine resource object."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine
}

output "id" {
  description = "An identifier for the engine, in the form 'projects/{{project}}/locations/{{region}}/semanticGovernancePolicyEngine'."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.id
}

output "name" {
  description = "The resource name of the engine, in the form 'projects/{project}/locations/{region}/semanticGovernancePolicyEngine'."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.name
}

output "state" {
  description = "The current state of the engine. One of STATE_UNSPECIFIED, PROVISIONING, ACTIVE, FAILED, DEPROVISIONING, INACTIVE."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.state
}

output "psc_service_attachment" {
  description = "The Private Service Connect service attachment URI for the engine's managed endpoint. Self-managed consumers target this to build their own PSC forwarding rule."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.psc_service_attachment
}

output "create_time" {
  description = "The time the engine was created, in RFC3339 UTC 'Zulu' format."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.create_time
}

output "update_time" {
  description = "The time the engine was last updated, in RFC3339 UTC 'Zulu' format."
  value       = google_vertex_ai_semantic_governance_policy_engine.policy_engine.update_time
}
