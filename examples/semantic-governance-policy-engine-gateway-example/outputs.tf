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

# Surface the module's by-name gateway_endpoints output. To read one field:
# module...gateway_endpoints["agent-gateway"].dns_record
output "gateway_endpoints" {
  value       = module.semantic_governance_policy_engine.gateway_endpoints
  description = "Map of gateway name to its full gateway object (inputs plus computed dns_record, ip_address, psc_endpoint, state)."
}
