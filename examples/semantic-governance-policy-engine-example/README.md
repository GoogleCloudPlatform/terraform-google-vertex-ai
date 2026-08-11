# Semantic Governance Policy Engine example

This example provisions a [Semantic Governance Policy Engine](https://cloud.google.com/gemini-enterprise-agent-platform/govern/policies/semantic-governance-overview) in a single region using the `semantic-governance-policy-engine` module.

Provisioning is a long-running operation (typically a few minutes, up to ~20), and `terraform destroy` triggers an asynchronous deprovision.

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
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |
| region | The region in which to provision the Semantic Governance Policy Engine | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| id | The engine identifier |
| project\_id | The project ID |
| psc\_service\_attachment | The Private Service Connect service attachment URI for the engine's managed endpoint |
| state | The current state of the engine |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
