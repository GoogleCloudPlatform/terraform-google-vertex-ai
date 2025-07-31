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

variable "location" {
  description = "The location of the template"
  type        = string
  default     = "global"
}

variable "parent_id" {
  type        = string
  description = "The ID of organization, folder, or project to create the floor settings in"
}

variable "parent_type" {
  type        = string
  description = "Parent type. Can be organization, folder, or project to create the floor settings in"
}

variable "enable_floor_setting_enforcement" {
  description = "Floor Settings enforcement status"
  type        = bool
  default     = true
}

variable "enable_malicious_uri_filter_settings" {
  description = "Enable Malicious URI filter settings"
  type        = bool
  default     = false
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

variable "ai_platform_floor_setting" {
  description = " AI Platform floor setting"
  type = object({
    inspect_only         = optional(bool)
    inspect_and_block    = optional(bool)
    enable_cloud_logging = optional(bool)
  })
  default = null
}

variable "enable_multi_language_detection" {
  description = "If true, multi language detection will be enabled"
  type        = bool
  default     = true
}

variable "integrated_services" {
  description = "List of integrated services for which the floor setting is applicable. Possible value is AI_PLATFORM"
  type        = list(any)
  default     = []
}
