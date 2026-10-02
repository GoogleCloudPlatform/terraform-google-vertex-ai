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

resource "google_vertex_ai_semantic_governance_policy" "policy" {
  project                       = var.project_id
  region                        = var.region
  semantic_governance_policy_id = var.semantic_governance_policy_id
  natural_language_constraint   = var.natural_language_constraint
  agent                         = var.agent
  display_name                  = var.display_name
  description                   = var.description
  deletion_policy               = var.deletion_policy

  dynamic "mcp_tools" {
    for_each = var.mcp_tools
    content {
      mcp_server = mcp_tools.value.mcp_server
      tools      = mcp_tools.value.tools
    }
  }

  dynamic "agent_response_customization" {
    for_each = var.denial_message == null || var.denial_message == "" ? [] : [var.denial_message]
    content {
      denial_message = agent_response_customization.value
    }
  }

  lifecycle {
    precondition {
      condition     = var.policy_engine_state == null || var.policy_engine_state == "ACTIVE"
      error_message = "The SemanticGovernancePolicyEngine must be ACTIVE before a policy can be created in this project and region."
    }
  }
}
