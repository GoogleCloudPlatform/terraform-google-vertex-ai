# Vertex AI Agent Engine Module

This module provisions a [Vertex AI Agent Engine](https://docs.cloud.google.com/agent-builder/agent-engine/overview)

## Simple Usage

Here's a basic example of how to use the module:

```terraform
module "agent_engine" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/agent-engine"

  project_id   = "your-gcp-project-id"
  display_name = "My Awesome Agent"
  region       = "us-central1"
  description  = "A simple example of a Reasoning Engine deployment"
}

output "reasoning_engine_id" {
  description = "ID of the deployed agent engine"
  value       = module.agent_engine.reasoning_engine_id
}
```

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| description | The description of the Reasoning Engine. | `string` | `null` | no |
| display\_name | The display name of the Reasoning Engine. | `string` | n/a | yes |
| kms\_key\_name | Customer-managed encryption key name for a Reasoning Engine. If set, this Reasoning Engine and all sub-resources will be secured by this key. | `string` | `null` | no |
| project\_id | The ID of the project in which the resource belongs. | `string` | n/a | yes |
| region | The region of the reasoning engine. eg us-central1. | `string` | n/a | yes |
| spec | Configurations of the Reasoning Engine. | <pre>object({<br>    agent_framework = optional(string)<br>    class_methods   = optional(list(any))<br>    deployment_spec = optional(object({<br>      container_concurrency = optional(number, 9)<br>      env                   = optional(map(string), {})<br>      max_instances         = optional(number, 100)<br>      min_instances         = optional(number, 1)<br>      psc_interface_config = optional(object({<br>        network_attachment = optional(string)<br>        dns_peering_configs = optional(list(object({<br>          domain         = string<br>          target_project = string<br>          target_network = string<br>        })), [])<br>      }))<br>      resource_limits = optional(map(string))<br>      secret_env = optional(list(object({<br>        name = string<br>        secret_ref = object({<br>          secret  = string<br>          version = optional(string)<br>        })<br>      })), [])<br>    }))<br>    package_spec = optional(object({<br>      dependency_files_gcs_uri = optional(string)<br>      pickle_object_gcs_uri    = optional(string)<br>      python_version           = optional(string)<br>      requirements_gcs_uri     = optional(string)<br>    }))<br>    source_code_spec = optional(object({<br>      python_spec = optional(object({<br>        entrypoint_module = optional(string)<br>        entrypoint_object = optional(string)<br>        requirements_file = optional(string)<br>        version           = optional(string, "3.10")<br>      }))<br>      developer_connect_source = optional(object({<br>        config = object({<br>          git_repository_link = string<br>          dir                 = string<br>          revision            = string<br>        })<br>      }))<br>    }))<br>    service_account = optional(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| reasoning\_engine | The full google\_vertex\_ai\_reasoning\_engine resource object. |
| reasoning\_engine\_id | The unique identifier for the Reasoning Engine resource. |
| reasoning\_engine\_name | The generated name of the Reasoning Engine. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
