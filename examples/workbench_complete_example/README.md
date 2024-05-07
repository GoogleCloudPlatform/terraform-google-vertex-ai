# Vertex AI Workbench Instance end to end complete example
Deploy private vertex AI Workbench Instance without proxy. Instance will be accessed using IAP (Identity aware proxy).

This example creates:
- Vertex AI workbench with CMEK encryption and custom service account [main.tf](./main.tf).
- CMEK key and IAM permissions needed for google managed service accounts [CMEK](./kms.tf).
- Metadata GCS bucket for hosting startup script [metadata startup script bucket](./metadata_gcs.tf).
- BYOD (Bring your own data) bucket for training model on user's data [BYOD bucket](./byod_gcs.tf).
- Set IAM permissions for instnace owner to access instance using [IAP](./iap.tf).
- Network & firewall rules [network](./network.tf).


## Usage

To run this example execute:

```bash
export TF_VAR_project_id="your_project_id"
export TF_VAR_instance_owners="your_email_address"
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
| instance\_owners | The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance | `list(string)` | <pre>[<br>  "test@example.com"<br>]</pre> | no |
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| kms\_key | The KMS key for Vertex AI Workbench instance |
| location | The location of the Vertex AI Workbench instance |
| network | The network for Vertex AI Workbench instance |
| project\_id | The project ID |
| service\_account | The service account for Vertex AI Workbench instance |
| subnet | The subnet for Vertex AI Workbench instance |
| workbench | The Vertex AI Workbench instance |
| workbench\_name | The name of the Vertex AI Workbench instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
