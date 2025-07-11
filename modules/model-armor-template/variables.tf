/**
 * Copyright 2025 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "template_id" {
  description = "The ID of the template"
  type        = string
}

variable "location" {
  description = "the location of the template"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "labels" {
  description = "Labels to apply to this template"
  type        = map(string)
  default     = {}
}

variable "enable_malicious_uri_filter_settings" {
  description = "Enable Malicious URI filter settings"
  type        = bool
  default     = false
}

variable "metadata_configs" {
  description = "Message describing Template Metadata"
  type = object({
    enforcement_type                         = optional(string, "")
    enable_multi_language_detection          = optional(bool)
    log_sanitize_operations                  = optional(bool, false)
    log_template_operations                  = optional(bool, false)
    ignore_partial_invocation_failures       = optional(bool, false)
    custom_prompt_safety_error_code          = optional(string)
    custom_prompt_safety_error_message       = optional(string)
    custom_llm_response_safety_error_message = optional(string)
    custom_llm_response_safety_error_code    = optional(string)
  })
  default = null
}

variable "rai_filters" {
  description = "Confidence level for Responsible AI filters"
  type = object({
    dangerous         = optional(string)
    sexually_explicit = optional(string)
    hate_speech       = optional(string)
    harassment        = optional(string)
  })
  default = null
}

variable "sdp_settings" {
  description = "Sensitive Data Protection settings"
  type = object({
    basic_config_filter_enforcement = optional(bool, false)
    advanced_config = optional(object({
      inspect_template    = optional(string)
      deidentify_template = optional(string)
    }))
  })
  default = null
}

variable "pi_and_jailbreak_filter_settings" {
  description = "Confidence level for Prompt injection and Jailbreak Filter settings"
  type        = string
  default     = null
}
