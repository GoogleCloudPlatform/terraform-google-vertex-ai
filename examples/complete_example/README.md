# Vertex AI Workbench Instance example
deploy vertex AI Workbench Instance

## Usage

To run this example you need to set parameters (see [example tfvar](./terraform.tfvars.example) file) and execute:


```bash
terraform init
terraform plan
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bucket\_timestamp | Timestamp of when access to BYOD will expire (ISO 8601 format - ex. 2020-01-01T00:00:00Z) | `string` | `null` | no |
| byod\_access\_group | The AD group able to access the bucket | `string` | `null` | no |
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
