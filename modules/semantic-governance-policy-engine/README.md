# Vertex AI (Gemini Enterprise Agent Platform) Semantic Governance Policy Engine Module

This module wraps the [`google_vertex_ai_semantic_governance_policy_engine`](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/vertex_ai_semantic_governance_policy_engine) resource. A Semantic Governance Policy Engine (SGPE) is the managed, runtime evaluation infrastructure for Semantic Governance Policies (SGP): the natural-language constraints that govern an AI agent's tool calls. You can find examples for this module here: the [minimal example](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/semantic-governance-policy-engine-example) and the [gateway example](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/semantic-governance-policy-engine-gateway-example)

The engine is a project-level, regional singleton — each project has at most one engine per region. Provisioning sets up managed Private Service Connect (PSC) networking in your VPC and a policy decision point that the Agent Gateway consults at runtime. The policies themselves and the Agent Gateway integration are configured separately and are not managed by this module.

```hcl
module "semantic_governance_policy_engine" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy-engine"
  version = "~> 7.4"

  project_id = var.project_id
  region     = "us-central1"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deletion\_policy | How Terraform treats destruction of the engine. One of DELETE (default; deprovision the engine), PREVENT (fail the destroy), or ABANDON (drop from state without deprovisioning). | `string` | `"DELETE"` | no |
| gateway\_configs | Customer-VPC PSC gateway configurations, keyed by gateway name (at most 5). Each entry provisions a Private Service Connect endpoint. Within an entry, network, subnetwork, and dns\_zone\_name must all be set together or all omitted (a partial set is rejected); when set, network and subnetwork are the resources' .id (not .self\_link, which the API rejects) and dns\_zone\_name is the private Cloud DNS zone the gateway's A-record is published into. allowed\_projects (optional) takes full 'projects/{id}' resource names. | <pre>map(object({<br>    network          = optional(string)<br>    subnetwork       = optional(string)<br>    dns_zone_name    = optional(string)<br>    allowed_projects = optional(list(string))<br>  }))</pre> | `{}` | no |
| project\_id | The ID of the project in which to create the SemanticGovernancePolicyEngine. | `string` | n/a | yes |
| region | The region of the SemanticGovernancePolicyEngine, e.g. 'us-central1'. Required by this module, even though the underlying resource treats region as optional. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_endpoints | List of gateway objects (each with the inputs plus the computed fields dns\_record, ip\_address, psc\_endpoint, state). |
| policy\_engine | The full google\_vertex\_ai\_semantic\_governance\_policy\_engine resource object. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Notes

- **`region` is required by this module**, even though the underlying resource treats it as optional.
- **Provisioning and deprovisioning are long-running.** A `terraform apply` that creates the engine kicks off a provisioning LRO (typically a few minutes, up to ~20). Destroying it is also asynchronous. The underlying resource's operation timeouts (60 minutes) bound these operations.
- **`policy_engine.psc_service_attachment` is the attribute most consumers need.** Self-managed customers target it to build their own PSC forwarding rule into the engine's managed endpoint.
- Reading an uninitialized or deprovisioned engine returns the singleton with state `INACTIVE` rather than reporting it as absent.
- **Reading per-gateway values.** The `gateway_endpoints` output is a list of the full gateway objects, so a caller reads one gateway's computed values by position — e.g. `module.<NAME>.gateway_endpoints[0].dns_record` (also `ip_address`, `psc_endpoint`, `state`). It is a list rather than a name-keyed map because Application Design Center connections select outputs by positional index; a Terraform consumer wanting by-name access can re-key it with `{ for g in module.<NAME>.gateway_endpoints : g.name => g }`. The [gateway example](../../examples/semantic-governance-policy-engine-gateway-example) shows the list output in its `outputs.tf`. The `policy_engine` output carries the same per-gateway values inside `policy_engine.gateway_configs`, but as a **set**, which cannot be indexed.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v8.1+

### Enable APIs

The following API must be enabled on the project where the engine is provisioned:

- `aiplatform.googleapis.com`

### Service Account

A service account (or user) with the following role must be used to provision the resources of this module:

- Vertex AI Administrator: `roles/aiplatform.admin`

[terraform]: https://www.terraform.io/downloads.html
[terraform-provider-gcp]: https://registry.terraform.io/providers/hashicorp/google/latest
