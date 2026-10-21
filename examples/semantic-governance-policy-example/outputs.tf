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

output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "name" {
  value       = module.semantic_governance_policy.policy.name
  description = "The resource name of the policy"
}

output "agent_identity" {
  value       = module.semantic_governance_policy.policy.agent_identity
  description = "The principal of the governed agent"
}

output "agent" {
  value       = module.semantic_governance_policy.policy.agent
  description = "The Agent Registry name of the governed agent"
}

output "registry_agent" {
  value       = data.google_agent_registry_agent.agent.id
  description = "The Agent Registry name the example looked up for its agent"
}

output "denial_message" {
  value       = one(module.semantic_governance_policy.policy.agent_response_customization[*].denial_message)
  description = "The denial message stored on the policy"
}

output "engine_state" {
  value       = module.semantic_governance_policy_engine.policy_engine.state
  description = "The state of the Semantic Governance Policy Engine"
}
