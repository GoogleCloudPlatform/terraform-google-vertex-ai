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

variable "project_id" {
  description = "The ID of the project in which to create the SemanticGovernancePolicy. The project must have an active SemanticGovernancePolicyEngine in the same region."
  type        = string
}

variable "region" {
  description = "The region of the SemanticGovernancePolicy, e.g. 'us-central1'. Must match the region of the project's SemanticGovernancePolicyEngine. Required by this module, even though the underlying resource treats region as optional."
  type        = string
}

variable "semantic_governance_policy_id" {
  description = "The ID of the policy, which becomes the final component of its resource name. Up to 63 characters from [a-z0-9-]; must start with a letter and end with a letter or number."
  type        = string

  validation {
    condition     = can(regex("^[a-z]([a-z0-9-]{0,61}[a-z0-9])?$", var.semantic_governance_policy_id))
    error_message = "semantic_governance_policy_id must be 1-63 characters from [a-z0-9-], start with a letter, and end with a letter or number."
  }
}

variable "natural_language_constraint" {
  description = "The rule the policy enforces, written in natural language. The policy engine blocks any tool call by the agent that violates it."
  type        = string

  validation {
    condition     = length(trimspace(var.natural_language_constraint)) > 0
    error_message = "natural_language_constraint must not be empty."
  }
}

variable "agent" {
  description = "The Agent Registry resource name of the agent this policy governs, in the form projects/{project}/locations/{location}/agents/{agent}. The agent must have an agent identity."
  type        = string

  validation {
    condition     = can(regex("^projects/[^/]+/locations/[^/]+/agents/[^/]+$", var.agent))
    error_message = "agent must have the form projects/{project}/locations/{location}/agents/{agent}."
  }
}

variable "display_name" {
  description = "The user-defined name of the policy."
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the policy."
  type        = string
  default     = null
}

variable "mcp_tools" {
  description = "Scopes the policy to a tool the agent calls through an MCP server. Each entry names an Agent Registry MCP server (projects/{project}/locations/{location}/mcpServers/{mcp_server}) and the tools it covers. Each tool is the tool's name as the MCP server lists it (for example get_order_status), not a resource name; a name that does not match exactly never matches a tool call. When empty, the policy applies to the agent as a whole."
  type = list(object({
    mcp_server = string
    tools      = list(string)
  }))
  default  = []
  nullable = false

  validation {
    condition     = alltrue([for t in var.mcp_tools : can(regex("^projects/[^/]+/locations/[^/]+/mcpServers/[^/]+$", t.mcp_server))])
    error_message = "Each mcp_tools[].mcp_server must have the form projects/{project}/locations/{location}/mcpServers/{mcp_server}."
  }

  validation {
    condition     = alltrue([for t in var.mcp_tools : t.tools == null ? false : length(t.tools) > 0 && alltrue([for name in t.tools : length(trimspace(name)) > 0 && !strcontains(name, "/")])])
    error_message = "Each mcp_tools entry must list at least one tool, and each tool must be a non-empty tool name (for example get_order_status), not a resource name."
  }
}

variable "denial_message" {
  description = "Message shown to the end user when this policy denies a tool call. Use it to explain the rationale. When null or empty, the default denial message is used."
  type        = string
  default     = null
}

variable "deletion_policy" {
  description = "How Terraform treats destruction of the policy: DELETE (delete the policy), PREVENT (fail the destroy), or ABANDON (drop from state without deleting). When null, the provider-level deletion_policy applies, which defaults to DELETE."
  type        = string
  default     = null

  validation {
    condition     = var.deletion_policy == null || contains(["DELETE", "PREVENT", "ABANDON"], coalesce(var.deletion_policy, "DELETE"))
    error_message = "deletion_policy must be null or one of DELETE, PREVENT, or ABANDON."
  }
}

variable "policy_engine_state" {
  description = "Optional. The state of the project's SemanticGovernancePolicyEngine, e.g. module.<engine>.policy_engine.state. Wiring it makes this policy wait for the engine and fails fast unless the engine is ACTIVE. Use it where depends_on is not available, such as Application Design Center connections; plain Terraform can use depends_on instead."
  type        = string
  default     = null
}
