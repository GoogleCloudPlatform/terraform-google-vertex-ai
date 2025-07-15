# Module for Model Armor Template

This module is used to create [Model Armor template](https://cloud.google.com/security-command-center/docs/key-concepts-model-armor#ma-templates). You can find example(s) for this module [here](../../examples/)

```hcl
module "model_armor_template" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/model-armor-template"
  version = "~> 2.0"

  template_id = "test-model-armor-template"
  location    = "us"
  project_id  = var.project_id

  rai_filters = {
    dangerous         = "LOW_AND_ABOVE"
    sexually_explicit = "MEDIUM_AND_ABOVE"
  }

  enable_malicious_uri_filter_settings = true

  pi_and_jailbreak_filter_settings = "MEDIUM_AND_ABOVE"

  sdp_settings = {
    basic_config_filter_enforcement = true
  }

  metadata_configs = {
    enforcement_type                         = "INSPECT_AND_BLOCK"
    enable_multi_language_detection          = true
    log_sanitize_operations                  = true
    log_template_operations                  = false
    ignore_partial_invocation_failures       = false
    custom_prompt_safety_error_code          = "799"
    custom_prompt_safety_error_message       = "error 799"
    custom_llm_response_safety_error_message = "error 798"
    custom_llm_response_safety_error_code    = "798"
  }

  labels = {
    "foo" = "bar"
  }
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| enable\_malicious\_uri\_filter\_settings | Enable Malicious URI filter settings | `bool` | `false` | no |
| labels | Labels to apply to this model armor template | `map(string)` | `{}` | no |
| location | the location of the template | `string` | n/a | yes |
| metadata\_configs | Message describing Template Metadata | <pre>object({<br>    enforcement_type                         = optional(string, "")<br>    enable_multi_language_detection          = optional(bool)<br>    log_sanitize_operations                  = optional(bool, false)<br>    log_template_operations                  = optional(bool, false)<br>    ignore_partial_invocation_failures       = optional(bool, false)<br>    custom_prompt_safety_error_code          = optional(string)<br>    custom_prompt_safety_error_message       = optional(string)<br>    custom_llm_response_safety_error_message = optional(string)<br>    custom_llm_response_safety_error_code    = optional(string)<br>  })</pre> | `null` | no |
| pi\_and\_jailbreak\_filter\_settings | Confidence level for Prompt injection and Jailbreak Filter settings | `string` | `null` | no |
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |
| rai\_filters | Confidence level for Responsible AI filters | <pre>object({<br>    dangerous         = optional(string)<br>    sexually_explicit = optional(string)<br>    hate_speech       = optional(string)<br>    harassment        = optional(string)<br>  })</pre> | `null` | no |
| sdp\_settings | Sensitive Data Protection settings | <pre>object({<br>    basic_config_filter_enforcement = optional(bool, false)<br>    advanced_config = optional(object({<br>      inspect_template    = optional(string)<br>      deidentify_template = optional(string)<br>    }))<br>  })</pre> | `null` | no |
| template\_id | The ID of the template | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| template | Model armor template created |

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

## metadata_configs
`log_template_operations` - (Optional) If true, log template crud operations.

`log_sanitize_operations` - (Optional) If true, log sanitize operations.

`multi_language_detection` - (Optional) Metadata to enable multi language detection via template. Structure is documented below.

`ignore_partial_invocation_failures` - (Optional) If true, partial detector failures should be ignored.

`custom_prompt_safety_error_code` - (Optional) Indicates the custom error code set by the user to be returned to the end user by the service extension if the prompt trips Model Armor filters.

`custom_prompt_safety_error_message` - (Optional) Indicates the custom error message set by the user to be returned to the end user if the prompt trips Model Armor filters.

`custom_llm_response_safety_error_code` - (Optional) Indicates the custom error code set by the user to be returned to the end user if the LLM response trips Model Armor filters.

`custom_llm_response_safety_error_message` - (Optional) Indicates the custom error message set by the user to be returned to the end user if the LLM response trips Model Armor filters.

`enforcement_type` - (Optional) Possible values: INSPECT_ONLY INSPECT_AND_BLOCK


`enable_multi_language_detection` - (Optional) If true, multi language detection will be enabled.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v6.43+

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- modelarmor.googleapis.com

### Service Account

A service account with the following roles must be used to provision the resources of this module:

- `roles/modelarmor.admin`
- `roles/modelarmor.floorSettingsAdmin`
