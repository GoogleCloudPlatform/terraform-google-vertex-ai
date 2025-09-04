<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bigtable\_cpu\_utilization\_target | The target CPU utilization percentage for Bigtable autoscaling. | `number` | `50` | no |
| bigtable\_max\_node\_count | The maximum number of nodes for Bigtable autoscaling. | `number` | `5` | no |
| bigtable\_min\_node\_count | The minimum number of nodes for Bigtable autoscaling. | `number` | `1` | no |
| create\_timeout | The timeout for creating the Feature Online Store. | `string` | `"30m"` | no |
| delete\_timeout | The timeout for deleting the Feature Online Store. | `string` | `"30m"` | no |
| enable\_private\_service\_connect | Set to true to enable Private Service Connect. | `bool` | `true` | no |
| featurestore\_name | The name of the Vertex AI Feature Online Store. | `string` | `"my-online-featurestore"` | no |
| kms\_key\_name | The full resource name of the KMS key to use for encryption. NOTE: This is not currently supported by the Terraform resource but is included for future compatibility. | `string` | `null` | no |
| labels | A map of labels to assign to the feature online store. | `map(string)` | <pre>{<br>  "env": "dev"<br>}</pre> | no |
| project\_id | The ID of the Google Cloud project. | `string` | n/a | yes |
| psc\_project\_allowlist | A list of project IDs from which to allow Private Service Connect connections. | `list(string)` | `[]` | no |
| region | The region where the Vertex AI Feature Online Store will be created. | `string` | `"us-central1"` | no |
| storage\_type | The storage type for the feature online store. Must be either 'optimized' or 'bigtable'. | `string` | `"optimized"` | no |
| update\_timeout | The timeout for updating the Feature Online Store. | `string` | `"30m"` | no |

## Outputs

| Name | Description |
|------|-------------|
| feature\_online\_store\_id | The full resource ID of the created Vertex AI Feature Online Store. |
| feature\_online\_store\_name\_output | The name of the created Vertex AI Feature Online Store. |
| psc\_service\_attachment | The service attachment URI for the Private Service Connect endpoint. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->