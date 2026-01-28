# Module for Model Armor Floor Settings

This module is used to create [Model Armor floor settings](https://cloud.google.com/security-command-center/docs/model_armor_floor_settings). You can find example(s) for this module [here](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/model-armor-floorsetting-example). `terraform destroy` will not reset model armor floor setting, instead if will delete resource from state file. If you want to reset model armor setting [follow these steps](#reset-model-armor-setting).

```hcl
module "model_armor_floorsetting" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-floorsetting"
  version = "~> 3.0"

  parent_id           = var.project_id
  parent_type         = "project"
  integrated_services = ["AI_PLATFORM"]

  rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
  }

  pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

  sdp_settings = {
    basic_config_filter_enforcement = true
  }

  ai_platform_floor_setting = {
    inspect_and_block    = true
    enable_cloud_logging = true
  }

}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| ai\_platform\_floor\_setting | AI Platform floor setting | <pre>object({<br>    inspect_only         = optional(bool)<br>    inspect_and_block    = optional(bool)<br>    enable_cloud_logging = optional(bool)<br>  })</pre> | `null` | no |
| enable\_floor\_setting\_enforcement | Floor Settings enforcement status | `bool` | `true` | no |
| enable\_malicious\_uri\_filter\_settings | Enable Malicious URI filter settings | `bool` | `false` | no |
| enable\_multi\_language\_detection | If true, multi language detection will be enabled | `bool` | `true` | no |
| google\_mcp\_server\_floor\_setting | Google MCP Server floor setting | <pre>object({<br>    inspect_only         = optional(bool)<br>    inspect_and_block    = optional(bool)<br>    enable_cloud_logging = optional(bool)<br>  })</pre> | `null` | no |
| integrated\_services | List of integrated services for which the floor setting is applicable. Possible values are AI\_PLATFORM, GOOGLE\_MCP\_SERVER | `list(any)` | `[]` | no |
| location | The location of the floor setting | `string` | `"global"` | no |
| parent\_id | The ID of organization, folder, or project to create the floor settings in | `string` | n/a | yes |
| parent\_type | Parent type. Can be organization, folder, or project to create the floor settings in | `string` | n/a | yes |
| pi\_and\_jailbreak\_filter\_settings | Confidence level for Prompt injection and Jailbreak Filter settings | `string` | `null` | no |
| rai\_filters | Confidence level for Responsible AI filters | <pre>object({<br>    dangerous         = optional(string)<br>    sexually_explicit = optional(string)<br>    hate_speech       = optional(string)<br>    harassment        = optional(string)<br>  })</pre> | `null` | no |
| sdp\_settings | Sensitive Data Protection settings | <pre>object({<br>    basic_config_filter_enforcement = optional(bool, false)<br>    advanced_config = optional(object({<br>      inspect_template    = optional(string)<br>      deidentify_template = optional(string)<br>    }))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| floorsetting | Model armor floor setting created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## rai_filters
You can set the confidence level for each content filter. Possible values are:

- LOW_AND_ABOVE
- MEDIUM_AND_ABOVE
- HIGH

## sdp_settings
- `basic_config_filter_enforcement:` enables Predefined infoTypes to detect [sensitive data types](https://cloud.google.com/security-command-center/docs/sanitize-prompts-responses#basic_sdp_configuration).

- `advanced_config:` Model Armor lets you screen LLM prompts and responses using [Sensitive Data Protection](https://cloud.google.com/security-command-center/docs/sanitize-prompts-responses#advanced_sdp_configuration) templates.

## pi_and_jailbreak_filter_settings
Detects [malicious content and jailbreak](https://cloud.google.com/security-command-center/docs/key-concepts-model-armor#ma-prompt-injection) attempts in a prompt. Possible values are

- LOW_AND_ABOVE
- MEDIUM_AND_ABOVE
- HIGH

## ai_platform_floor_setting
`inspect_only` - If true, Model Armor filters will be run in inspect only mode. No action will be taken on the request.

`inspect_and_block` - (Optional) If true, Model Armor filters will be run in inspect and block mode. Requests that trip Model Armor filters will be blocked.

`enable_cloud_logging` - (Optional) If true, log Model Armor filter results to Cloud Logging.


## reset-model-armor-setting

```shell
export PROJECT_ID="YOUR-PROJECT_ID"
gcloud model-armor floorsettings update --full-uri=projects/${PROJECT_ID}/locations/global/floorSetting --enable-floor-setting-enforcement=false
```

```
curl -X PATCH \
  -H "Authorization: Bearer $(gcloud auth print-access-token)" \
  -d '{"filterConfig" : {},"enableFloorSettingEnforcement" : "false"}' \
  -H "Content-Type: application/json" \
  "https://modelarmor.googleapis.com/v1/projects/${PROJECT_ID}/locations/global/floorSetting"
```


## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v7.13+

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- modelarmor.googleapis.com
- aiplatform.googleapis.com

### Service Account

A service account with the following roles must be used to provision the resources of this module:

- `roles/modelarmor.admin`
- `roles/modelarmor.floorSettingsAdmin`
