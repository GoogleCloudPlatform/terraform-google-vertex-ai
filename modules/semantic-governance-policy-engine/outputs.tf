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

# gateway_configs is a set on the resource, which cannot be indexed. Expose it
# as a list -- not a name-keyed map -- so consumers can select a gateway by
# positional index (e.g. gateway_endpoints[0].dns_record); Application Design
# Center connections support positional index but not string-key map access.
output "gateway_endpoints" {
  description = "List of gateway objects (each with the inputs plus the computed fields dns_record, ip_address, psc_endpoint, state)."
  value       = tolist(google_vertex_ai_semantic_governance_policy_engine.policy_engine.gateway_configs)
}
