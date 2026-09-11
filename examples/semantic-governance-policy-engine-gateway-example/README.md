# Semantic Governance Policy Engine with a PSC gateway example

This example provisions a [Semantic Governance Policy Engine](https://cloud.google.com/gemini-enterprise-agent-platform/govern/policies/semantic-governance-overview) and attaches one customer-VPC Private Service Connect (PSC) gateway to it via the module's `gateway_configs` input.

Unlike the [minimal example](../semantic-governance-policy-engine-example), which provisions the engine with no gateways, this one also creates the networking a gateway needs — a VPC network, a subnetwork, and a private Cloud DNS zone — and references them from a `gateway_configs` entry. The engine creates a consumer-side PSC endpoint and publishes an A-record for the gateway into the private zone.

Each gateway entry must set `network`, `subnetwork`, and `dns_zone_name` together; the engine rejects a partial set. The network and subnetwork are passed as their full resource URIs — the resources' `.id` (of the form `projects/P/global/networks/N`), not `.self_link` (the `https://` form the API rejects) — so the configuration matches what the API stores and the gateway does not churn on later plans.

> **Note:** provisioning the engine and each gateway is a long-running operation (typically a few minutes, up to ~20), and it creates real PSC/DNS infrastructure. This example is provided as a reference for using `gateway_configs`; it is not part of the module's automated integration test suite.

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
| dns\_name | DNS suffix for the private managed zone (must be a fully-qualified name ending in a dot). | `string` | `"internal.sgp.local."` | no |
| dns\_zone\_name | Name of the private Cloud DNS managed zone the engine publishes the gateway's A-record into. | `string` | `"sgp-private-zone"` | no |
| gateway\_name | Name of the PSC gateway (used as the key in the engine's gateway\_configs map). | `string` | `"agent-gateway"` | no |
| network\_name | Name of the VPC network the PSC gateway attaches to. | `string` | `"agent-network"` | no |
| project\_id | The ID of the project in which the resources belong. | `string` | n/a | yes |
| region | The region in which to provision the engine and the gateway's subnetwork. | `string` | `"us-central1"` | no |
| subnetwork\_cidr | Primary IPv4 CIDR range for the subnetwork. | `string` | `"10.0.0.0/24"` | no |
| subnetwork\_name | Name of the subnetwork the PSC gateway attaches to. | `string` | `"agent-subnet"` | no |

## Outputs

| Name | Description |
|------|-------------|
| gateway\_endpoints | Map of gateway name to its full gateway object (inputs plus computed dns\_record, ip\_address, psc\_endpoint, state). |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
