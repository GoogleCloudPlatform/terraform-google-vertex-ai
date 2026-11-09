# Module for Model Armor Floor Settings

This module is used to create [Model Armor floor settings](https://cloud.google.com/security-command-center/docs/model_armor_floor_settings). You can find example(s) for this module [here](https://github.com/GoogleCloudPlatform/terraform-google-vertex-ai/tree/main/examples/model-armor-floorsetting-example). `terraform destroy` will not reset model armor floor setting, instead if will delete resource from state file. If you want to reset model armor setting [follow these steps](#reset-model-armor-setting).

```hcl
module "model_armor_floorsetting" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-floorsetting"
  version = "~> 10.0"

  project_id          = var.project_id
  integrated_services = ["AI_PLATFORM"]

  rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
  }

  pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

  sdp_settings = {
    basic_config_filter_enforcement = "ENABLED"
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
| ai\_platform\_floor\_setting | Configure the AI Platform floor setting; Note: Value AI\_PLATFORM must be in Integrated Services Field. | <pre>object({<br>    inspect_only         = optional(bool)<br>    inspect_and_block    = optional(bool)<br>    enable_cloud_logging = optional(bool)<br>  })</pre> | `null` | no |
| enable\_floor\_setting\_enforcement | Floor Settings enforcement status | `bool` | `true` | no |
| enable\_multi\_language\_detection | Enable multi-language detection for floor setting. Set to null to omit floor\_setting\_metadata. | `bool` | `true` | no |
| folder\_id | Numeric Folder ID where the floor setting will be applied. Mutually exclusive with project\_id and org\_id. | `string` | `null` | no |
| google\_mcp\_server\_floor\_setting | Configure the Google MCP Server floor setting; Note: Value GOOGLE\_MCP\_SERVER must be in Integrated Services Field. | <pre>object({<br>    inspect_only         = optional(bool)<br>    inspect_and_block    = optional(bool)<br>    enable_cloud_logging = optional(bool)<br>  })</pre> | `null` | no |
| integrated\_services | List of integrated services for which the floor setting is applicable. Possible values are AI\_PLATFORM, GOOGLE\_MCP\_SERVER | `list(string)` | `[]` | no |
| malicious\_uri\_filter\_settings | Malicious URI filter enforcement status. Possible values are ENABLED or DISABLED. Set to null to omit. | `string` | `null` | no |
| org\_id | Numeric Organization ID where the floor setting will be applied. Mutually exclusive with project\_id and folder\_id. | `string` | `null` | no |
| pi\_and\_jailbreak\_filter\_settings | Confidence level for Prompt injection and Jailbreak Filter settings (LOW\_AND\_ABOVE, MEDIUM\_AND\_ABOVE, HIGH), or DISABLED to explicitly disable the filter. | `string` | `null` | no |
| project\_id | Google Cloud Project ID where the floor setting will be applied. Mutually exclusive with folder\_id and org\_id. | `string` | `null` | no |
| rai\_filters | Confidence level for Responsible AI filters | <pre>object({<br>    dangerous         = optional(string)<br>    sexually_explicit = optional(string)<br>    hate_speech       = optional(string)<br>    harassment        = optional(string)<br>  })</pre> | `null` | no |
| sdp\_settings | Sensitive Data Protection settings. Configure either basic\_config\_filter\_enforcement (ENABLED or DISABLED) or advanced\_config. | <pre>object({<br>    basic_config_filter_enforcement = optional(string)<br>    advanced_config = optional(object({<br>      inspect_template    = optional(string)<br>      deidentify_template = optional(string)<br>    }))<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| create\_time | Timestamp when the Model Armor floor setting was created. |
| floorsetting | Model armor floor setting created |
| id | An identifier for the Model Armor floor setting resource. |
| name | The resource name of the Model Armor floor setting. |
| parent | The parent resource path (projects/{project}, folders/{folder}, or organizations/{organizationId}). |
| update\_time | Timestamp when the Model Armor floor setting was last updated. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## rai_filters
You can set the confidence level for each content filter. Possible values are:

- LOW_AND_ABOVE
- MEDIUM_AND_ABOVE
- HIGH

## sdp_settings
- `basic_config_filter_enforcement:` enables or disables Predefined infoTypes to detect [sensitive data types](https://cloud.google.com/security-command-center/docs/sanitize-prompts-responses#basic_sdp_configuration). Possible values are `ENABLED`, `DISABLED`, or `null` to omit. Mutually exclusive with `advanced_config`.

- `advanced_config:` Model Armor lets you screen LLM prompts and responses using [Sensitive Data Protection](https://cloud.google.com/security-command-center/docs/sanitize-prompts-responses#advanced_sdp_configuration) templates (`inspect_template` and/or `deidentify_template`). Mutually exclusive with `basic_config_filter_enforcement`.

## pi_and_jailbreak_filter_settings
Detects [malicious content and jailbreak](https://cloud.google.com/security-command-center/docs/key-concepts-model-armor#ma-prompt-injection) attempts in a prompt. Possible values are:

- LOW_AND_ABOVE
- MEDIUM_AND_ABOVE
- HIGH
- DISABLED (explicitly disables the filter)

## malicious_uri_filter_settings
Controls Malicious URI filter enforcement. Possible values are:

- ENABLED
- DISABLED
- `null` (default; omits `malicious_uri_filter_settings`)

## enable_multi_language_detection
Set to `true` (default) or `false` to configure `floor_setting_metadata.multi_language_detection.enable_multi_language_detection`. Set to `null` to omit the `floor_setting_metadata` block completely.

## ai_platform_floor_setting
Requires `"AI_PLATFORM"` in `integrated_services`. Exactly one of `inspect_only` or `inspect_and_block` must be set to `true`:

`inspect_only` - If true, Model Armor filters will be run in inspect only mode. No action will be taken on the request.

`inspect_and_block` - (Optional) If true, Model Armor filters will be run in inspect and block mode. Requests that trip Model Armor filters will be blocked.

`enable_cloud_logging` - (Optional) If true, log Model Armor filter results to Cloud Logging.

## google_mcp_server_floor_setting
Requires `"GOOGLE_MCP_SERVER"` in `integrated_services`. Exactly one of `inspect_only` or `inspect_and_block` must be set to `true`:

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
- dlp.googleapis.com (required when configuring `sdp_settings`)

### Service Account

A service account with the following roles must be used to provision the resources of this module:

- `roles/modelarmor.admin`
- `roles/modelarmor.floorSettingsAdmin`
