<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| git\_repository\_dir | Directory, relative to the source root, in which to run the build. | `string` | n/a | yes |
| git\_repository\_link | The Developer Connect Git repository link, formatted as projects//locations//connections//gitRepositoryLink/. | `string` | n/a | yes |
| project\_id | The ID of the Google Cloud project in which to deploy the Reasoning Engine. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project | The project ID where the ReasoningEngine was created. |
| reasoning\_engine | The generated name of the Reasoning Engine. |
| reasoning\_engine\_id | The unique identifier for the created ReasoningEngine resource. |
| reasoning\_engine\_name | The generated name of the created ReasoningEngine. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
