# Model Armor Floor Setting example
Deploy Model Armor floor setting.


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
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| model\_armor\_floorsetting | floor setting created |
| project\_id | The project ID |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
