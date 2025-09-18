<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| featurestore\_name | The name of the Vertex AI feature online store. | `string` | n/a | yes |
| project\_id | The ID of the Google Cloud project. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| feature\_online\_store\_id | The full resource ID of the created Vertex AI Feature Online Store. |
| feature\_online\_store\_name\_output | The name of the created Vertex AI Feature Online Store. |
| psc\_service\_attachment | The service attachment URI for the Private Service Connect endpoint. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
