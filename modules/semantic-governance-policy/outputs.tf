/**
 * Copyright 2026 Google LLC
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

output "name" {
  description = "The resource name of the policy, in the form projects/{project}/locations/{location}/semanticGovernancePolicies/{semantic_governance_policy_id}."
  value       = google_vertex_ai_semantic_governance_policy.policy.name
}

output "agent_identity" {
  description = "The principal of the governed agent, used by the Policy Decision Point (PDP) for governance checks."
  value       = google_vertex_ai_semantic_governance_policy.policy.agent_identity
}

output "policy" {
  description = "The full google_vertex_ai_semantic_governance_policy resource object."
  value       = google_vertex_ai_semantic_governance_policy.policy
}
