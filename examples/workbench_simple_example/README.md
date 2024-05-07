# Vertex AI Workbench Instance simple example
Deploy private vertex AI Workbench Instance without proxy. Instance will be accessed using IAP (Identity aware proxy).

This example also creates:
- Vertex AI workbench with custom service account [main.tf](./main.tf).
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
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| network | The network for Vertex AI Workbench instance |
| project\_id | The project ID |
| service\_account | The service account for Vertex AI Workbench instance |
| subnet | The subnet for Vertex AI Workbench instance |
| workbench | The Vertex AI Workbench instance |
| workbench\_name | The name of the Vertex AI Workbench instance |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
