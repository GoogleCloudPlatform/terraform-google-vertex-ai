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

# gateway_configs is a set on the resource, so it cannot be indexed by name.
# Re-key it into a map (mirroring the gateway_configs input) so a caller can
# read one gateway by name -- e.g. gateway_endpoints["<name>"].dns_record. Each
# value is the full gateway object: the inputs plus the computed fields
# (state, ip_address, psc_endpoint, dns_record).
output "gateway_endpoints" {
  description = "Map of gateway name to its full gateway object (the inputs plus the computed fields dns_record, ip_address, psc_endpoint, state)."
  value       = { for g in google_vertex_ai_semantic_governance_policy_engine.policy_engine.gateway_configs : g.name => g }
}
