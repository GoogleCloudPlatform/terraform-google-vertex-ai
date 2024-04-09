# Vertex AI Workbench Instance example
Deploy vertex AI Workbench Instance.

This example also creates:
- Vertex AI workbench with CMEK encryption and custom service account [main.tf](./main.tf).
- CMEK key and IAM permissions needed for google managed service accounts [CMEK](./kms.tf).
- Metadata GCS bucket for hosting startup script [metadata startup script bucket](./metadata_gcs.tf).
- BYOD (Bring your own data) bucket for training model on user's data [BYOD bucket](./byod_gcs.tf).
- Set IAM permissions for instnace owner to access instance using [IAP](./iap.tf).
- Network & firewall rules [network](./network.tf).


## Usage

To run this example execute:


```bash
terraform init
terraform plan
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| instance\_owners | The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance | `list(string)` | <pre>[<br>  "imrannayer@google.com"<br>]</pre> | no |
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| creator | Email address of entity that sent original CreateInstance request. |
| gcs\_bucket\_url | n/a |
| health\_info | Additional information about the the Vertex AI Workbench instance's health. |
| health\_state | The health state of the Vertex AI Workbench instance. |
| id | The Vertex AI Workbench instance ID. |
| proxy\_uri | The proxy endpoint that is used to access the Jupyter notebook. |
| state | The state of the Vertex AI Workbench instance. |
| upgrade\_history | The upgrade history of the Vertex AI Workbench instance. |
| work\_bench | Workbenchs created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
