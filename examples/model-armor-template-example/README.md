# Model Armor Template example
Deploy Model Armor template.


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
| location | Location of the template created |
| model\_armor\_template | Template created |
| name | Name of the template created |
| project\_id | The project ID |
| template\_id | Template id of the template created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
