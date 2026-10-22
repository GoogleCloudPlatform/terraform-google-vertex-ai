# Semantic Governance Policy example

This example creates a [Semantic Governance Policy](https://cloud.google.com/gemini-enterprise-agent-platform/govern/policies/semantic-governance-overview) for an agent using the `semantic-governance-policy` module. It also creates what the policy needs: a Semantic Governance Policy Engine in the same region (with the `semantic-governance-policy-engine` module) and an Agent Engine agent, which it then looks up in Agent Registry.

A policy can only be created once the engine is active, and the policy has no attribute that references the engine, so the example passes the engine's id to the policy module's `module_depends_on` input, which orders the policy after the engine. `depends_on` on the policy module works too. Engine provisioning is a long-running operation (typically a few minutes, up to ~20). The example also waits 120 seconds for Agent Registry to register the new agent.

## Usage

To run this example execute:

```bash
export TF_VAR_project_id="your_project_id"
```

```tf
terraform init
terraform plan
terraform apply
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the project in which the resources are created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| agent | The Agent Registry name of the governed agent |
| agent\_identity | The principal of the governed agent |
| denial\_message | The denial message stored on the policy |
| engine\_state | The state of the Semantic Governance Policy Engine |
| name | The resource name of the policy |
| project\_id | The project ID |
| registry\_agent | The Agent Registry name the example looked up for its agent |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
