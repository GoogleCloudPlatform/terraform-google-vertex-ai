# Vertex AI Reasoning Engine Module

This module provisions a Vertex AI Reasoning Engine.

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | The description of the Reasoning Engine. | `string` | `null` | no |
| display\_name | The display name of the Reasoning Engine. | `string` | n/a | yes |
| encryption\_spec | Customer-managed encryption key spec for a Reasoning Engine. If set, this Reasoning Engine and all sub-resources of this ReasoningEngine will be secured by this key. | <pre>object({<br>    kms_key_name = string<br>  })</pre> | `null` | no |
| project | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| region | The region of the reasoning engine. eg us-central1. | `string` | n/a | yes |
| spec | Configurations of the ReasoningEngine. | <pre>object({<br>    agent_framework = optional(string)<br>    class_methods   = optional(list(any)) # Adjust 'any' if a more specific type is known<br>    deployment_spec = optional(object({<br>      env = optional(list(object({<br>        name  = string<br>        value = string<br>      })))<br>      secret_env = optional(list(object({<br>        name       = string<br>        secret_ref = object({<br>          secret  = string<br>          version = optional(string)<br>        })<br>      })))<br>    }))<br>    package_spec = optional(object({<br>      dependency_files_gcs_uri = optional(string)<br>      pickle_object_gcs_uri    = optional(string)<br>      python_version           = optional(string)<br>      requirements_gcs_uri     = optional(string)<br>    }))<br>    service_account = optional(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| reasoning\_engine\_create\_time | The timestamp of when the Reasoning Engine was created. |
| reasoning\_engine\_id | The unique identifier for the Reasoning Engine resource. |
| reasoning\_engine\_name | The generated name of the Reasoning Engine. |
| reasoning\_engine\_update\_time | The timestamp of when the Reasoning Engine was last updated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->