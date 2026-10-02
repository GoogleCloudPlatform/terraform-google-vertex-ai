# Vertex AI (Gemini Enterprise Agent Platform) Semantic Governance Policy Module

This module wraps the [`google_vertex_ai_semantic_governance_policy`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_semantic_governance_policy) resource. A Semantic Governance Policy (SGP) is a natural-language constraint that governs an AI agent's tool calls. At runtime, the Agent Gateway sends each tool call the agent proposes to the project's Semantic Governance Policy Engine, which blocks calls that violate the agent's policies. You can find an example for this module [here](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/semantic-governance-policy-example).

A policy can only be created in a project and region that already has an active Semantic Governance Policy Engine. The engine is provisioned separately, for example with the [`semantic-governance-policy-engine`](../semantic-governance-policy-engine) module.

```hcl
module "semantic_governance_policy" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy"
  version = "~> 8.0"

  project_id                    = var.project_id
  region                        = "us-central1"
  semantic_governance_policy_id = "no-internal-endpoints"
  natural_language_constraint   = "Do not call internal developer endpoints."
  agent                         = "projects/my-project/locations/us-central1/agents/my-agent"

  depends_on = [module.semantic_governance_policy_engine]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agent | The Agent Registry resource name of the agent this policy governs, in the form projects/{project}/locations/{location}/agents/{agent}. The agent must have an agent identity. | `string` | n/a | yes |
| deletion\_policy | How Terraform treats destruction of the policy: DELETE (delete the policy), PREVENT (fail the destroy), or ABANDON (drop from state without deleting). When null, the provider-level deletion\_policy applies, which defaults to DELETE. | `string` | `null` | no |
| denial\_message | Message shown to the end user when this policy denies a tool call. Use it to explain the rationale. When null or empty, the default denial message is used. | `string` | `null` | no |
| description | The description of the policy. | `string` | `null` | no |
| display\_name | The user-defined name of the policy. | `string` | `null` | no |
| mcp\_tools | Scopes the policy to a tool the agent calls through an MCP server. Each entry names an Agent Registry MCP server (projects/{project}/locations/{location}/mcpServers/{mcp\_server}) and the tools it covers. Each tool is the tool's name as the MCP server lists it (for example get\_order\_status), not a resource name; a name that does not match exactly never matches a tool call. When empty, the policy applies to the agent as a whole. | <pre>list(object({<br>    mcp_server = string<br>    tools      = list(string)<br>  }))</pre> | `[]` | no |
| natural\_language\_constraint | The rule the policy enforces, written in natural language. The policy engine blocks any tool call by the agent that violates it. | `string` | n/a | yes |
| policy\_engine\_state | Optional. The state of the project's SemanticGovernancePolicyEngine, e.g. module.<engine>.policy\_engine.state. Wiring it makes this policy wait for the engine and fails fast unless the engine is ACTIVE. Use it where depends\_on is not available, such as Application Design Center connections; plain Terraform can use depends\_on instead. | `string` | `null` | no |
| project\_id | The ID of the project in which to create the SemanticGovernancePolicy. The project must have an active SemanticGovernancePolicyEngine in the same region. | `string` | n/a | yes |
| region | The region of the SemanticGovernancePolicy, e.g. 'us-central1'. Must match the region of the project's SemanticGovernancePolicyEngine. Required by this module, even though the underlying resource treats region as optional. | `string` | n/a | yes |
| semantic\_governance\_policy\_id | The ID of the policy, which becomes the final component of its resource name. Up to 63 characters from [a-z0-9-]; must start with a letter and end with a letter or number. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| agent\_identity | The principal of the governed agent, used by the Policy Decision Point (PDP) for governance checks. |
| name | The resource name of the policy, in the form projects/{project}/locations/{location}/semanticGovernancePolicies/{semantic\_governance\_policy\_id}. |
| policy | The full google\_vertex\_ai\_semantic\_governance\_policy resource object. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

- **An active engine is a hard prerequisite.** The API rejects a create unless a Semantic Governance Policy Engine is active in the same project and region, and the policy has no attribute that references the engine. When both are managed in one configuration, order them with `depends_on` (see the usage above); the engine's create blocks until provisioning finishes. Where `depends_on` is not available, as in Application Design Center connections, wire the engine's state into `policy_engine_state` instead (`module.<engine>.policy_engine.state`). That also fails the plan early if the engine is not `ACTIVE`.
- **`agent` is an Agent Registry resource name**, not an Agent Engine name. Agent Registry registers an Agent Engine agent asynchronously after it is created; the [example](../../examples/semantic-governance-policy-example) waits for registration and then reads the name with the `google_agent_registry_agent` data source. The agent must have an agent identity (for Agent Engine, `identity_type = "AGENT_IDENTITY"`).
- **`mcp_tools[].tools` are tool names, not resource names.** At runtime the policy engine matches each entry exactly against the names of the tools the agent calls (for example `get_order_status`). A name that does not match exactly never applies, without any error, so the module rejects values that look like resource names. Leave `mcp_tools` empty to apply the policy to the agent as a whole.
- **`deletion_policy` defaults to the provider-level setting.** When unset, the provider's `deletion_policy` applies (which defaults to `DELETE`).
- **`region` is required by this module**, even though the underlying resource treats it as optional.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v8.5+

### Enable APIs

The following APIs must be enabled on the project where the policy is created:

- `aiplatform.googleapis.com`
- `agentregistry.googleapis.com`

### Service Account

A service account (or user) with the following roles must be used to provision the resources of this module. The API reads the agent and MCP server from Agent Registry with the caller's credentials when a policy is created.

- Vertex AI Administrator: `roles/aiplatform.admin`
- Agent Registry API Viewer: `roles/agentregistry.viewer`

[terraform]: https://www.terraform.io/downloads.html
[terraform-provider-gcp]: https://registry.terraform.io/providers/hashicorp/google/latest
