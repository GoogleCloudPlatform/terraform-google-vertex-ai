# Vertex AI (Gemini Enterprise Agent Platform) Semantic Governance Policy Engine Module

This module wraps the [`google_vertex_ai_semantic_governance_policy_engine`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_semantic_governance_policy_engine) resource. A Semantic Governance Policy Engine (SGPE) is the managed, runtime evaluation infrastructure for Semantic Governance Policies (SGP): the natural-language constraints that govern an AI agent's tool calls. You can find example(s) for this module [here](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/semantic-governance-policy-engine-example)

The engine is a project-level, regional singleton — each project has at most one engine per region. Provisioning sets up managed Private Service Connect (PSC) networking in your VPC and a policy decision point that the Agent Gateway consults at runtime. The policies themselves and the Agent Gateway integration are configured separately and are not managed by this module.

```hcl
module "semantic_governance_policy_engine" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy-engine"
  version = "~> 7.3"

  project_id = var.project_id
  region     = "us-central1"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deletion\_policy | How Terraform treats destruction of the engine. One of DELETE (default; deprovision the engine), PREVENT (fail the destroy), or ABANDON (drop from state without deprovisioning). | `string` | `"DELETE"` | no |
| project\_id | The ID of the project in which to create the SemanticGovernancePolicyEngine. | `string` | n/a | yes |
| region | The region of the SemanticGovernancePolicyEngine, e.g. 'us-central1'. Required by this module, even though the underlying resource treats region as optional. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| policy\_engine | The full google\_vertex\_ai\_semantic\_governance\_policy\_engine resource object. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

- **`region` is required by this module**, even though the underlying resource treats it as optional.
- **Provisioning and deprovisioning are long-running.** A `terraform apply` that creates the engine kicks off a provisioning LRO (typically a few minutes, up to ~20). Destroying it is also asynchronous. The `timeout_*` variables (each defaulting to `60m`) bound these operations.
- **`psc_service_attachment` is the output most consumers need.** Self-managed customers target it to build their own PSC forwarding rule into the engine's managed endpoint.
- Reading an uninitialized or deprovisioned engine returns the singleton with state `INACTIVE` rather than reporting it as absent.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v7.41+

### Enable APIs

The following API must be enabled on the project where the engine is provisioned:

- `aiplatform.googleapis.com`

### Service Account

A service account (or user) with the following role must be used to provision the resources of this module:

- Vertex AI Administrator: `roles/aiplatform.admin`

[terraform]: https://www.terraform.io/downloads.html
[terraform-provider-gcp]: https://registry.terraform.io/providers/hashicorp/google/latest
