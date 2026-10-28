# Semantic Governance Policy Engine with a PSC gateway example

This example provisions a [Semantic Governance Policy Engine](https://cloud.google.com/gemini-enterprise-agent-platform/govern/policies/semantic-governance-overview) and attaches one customer-VPC Private Service Connect (PSC) gateway to it via the module's `gateway_configs` input.

Unlike the [minimal example](../semantic-governance-policy-engine-example), which provisions the engine with no gateways, this one also creates the networking a gateway needs — a VPC network, a subnetwork, and a private Cloud DNS zone — and references them from a `gateway_configs` entry. The engine creates a consumer-side PSC endpoint and publishes an A-record for the gateway into the private zone.

Within a gateway entry, `network`, `subnetwork`, and `dns_zone_name` must be set together or all omitted; a partial set is rejected — this example sets all three. Network and subnetwork are passed as their full resource URIs — the resources' `.id` (of the form `projects/P/global/networks/N`), not `.self_link` (the `https://` form the API rejects) — so the configuration matches what the API stores and the gateway does not churn on later plans.

The engine attaches the gateway as the project's Vertex AI service agent (`service-PROJECT_NUMBER@gcp-sa-aiplatform.iam.gserviceaccount.com`), so the example creates the agent (`google_project_service_identity`) and grants it `roles/compute.networkAdmin` and `roles/dns.admin` on the project before creating the engine. Without them the gateway reaches `FAILED` while the engine reports `ACTIVE`. The agent also needs these roles to remove the gateway when the engine is deleted, so they must stay in place until the engine is gone; the example waits 120 seconds after creating them and before removing them. Note that destroying a `google_project_iam_member` removes that role binding even if it was also granted outside Terraform.

> **Note:** provisioning the engine and each gateway is a long-running operation (typically a few minutes, up to ~20), and it creates real PSC/DNS infrastructure. The integration test `TestSemanticGovernancePolicyEngineGatewayExample` applies this example.

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
| project\_id | The ID of the project in which the resources belong. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_endpoints | List of gateway objects (each with inputs plus computed dns\_record, ip\_address, psc\_endpoint, state). |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
