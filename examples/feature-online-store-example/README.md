<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The ID of the Google Cloud project. | `string` | n/a | yes |
| region | The GCP region for the Feature Online Store. | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| feature\_online\_store\_id | The full resource ID of the created Vertex AI Feature Online Store. |
| feature\_online\_store\_name\_output | The name of the created Vertex AI Feature Online Store. |
| project\_id | The project ID |
| psc\_service\_attachment | The service attachment URI for the Private Service Connect endpoint. |
| region | The region |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
