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

variable "project_id" {
  description = "Google Cloud Project ID where the floor setting will be applied. Mutually exclusive with folder_id and org_id."
  type        = string
  default     = null

  validation {
    condition = var.project_id == null || (
      length(trimspace(var.project_id != null ? var.project_id : "x")) > 0 &&
      !can(regex("^projects/", var.project_id != null ? var.project_id : "x"))
    )
    error_message = "project_id must be a non-empty project ID without a 'projects/' prefix."
  }
}

variable "folder_id" {
  description = "Numeric Folder ID where the floor setting will be applied. Mutually exclusive with project_id and org_id."
  type        = string
  default     = null

  validation {
    condition     = var.folder_id == null || can(regex("^[0-9]+$", var.folder_id != null ? var.folder_id : "0"))
    error_message = "folder_id must be a numeric folder ID without a 'folders/' prefix."
  }
}

variable "org_id" {
  description = "Numeric Organization ID where the floor setting will be applied. Mutually exclusive with project_id and folder_id."
  type        = string
  default     = null

  validation {
    condition     = var.org_id == null || can(regex("^[0-9]+$", var.org_id != null ? var.org_id : "0"))
    error_message = "org_id must be a numeric organization ID without an 'organizations/' prefix."
  }
}

variable "enable_floor_setting_enforcement" {
  description = "Floor Settings enforcement status"
  type        = bool
  default     = true
  nullable    = false
}

variable "malicious_uri_filter_settings" {
  description = "Malicious URI filter enforcement status. Possible values are ENABLED or DISABLED. Set to null to omit."
  type        = string
  default     = null

  validation {
    condition     = var.malicious_uri_filter_settings == null || contains(["ENABLED", "DISABLED"], var.malicious_uri_filter_settings != null ? var.malicious_uri_filter_settings : "ENABLED")
    error_message = "malicious_uri_filter_settings must be either ENABLED, DISABLED, or null."
  }
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

  validation {
    condition = var.rai_filters == null || alltrue([
      for v in [
        try(var.rai_filters.dangerous, null),
        try(var.rai_filters.sexually_explicit, null),
        try(var.rai_filters.hate_speech, null),
        try(var.rai_filters.harassment, null),
      ] : v == null || contains(["LOW_AND_ABOVE", "MEDIUM_AND_ABOVE", "HIGH"], v != null ? v : "HIGH")
    ])
    error_message = "Each configured rai_filters attribute must be one of LOW_AND_ABOVE, MEDIUM_AND_ABOVE, or HIGH."
  }
}

variable "sdp_settings" {
  description = "Sensitive Data Protection settings. Configure either basic_config_filter_enforcement (ENABLED or DISABLED) or advanced_config."
  type = object({
    basic_config_filter_enforcement = optional(string)
    advanced_config = optional(object({
      inspect_template    = optional(string)
      deidentify_template = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.sdp_settings == null || (
      (
        try(var.sdp_settings.basic_config_filter_enforcement, null) == null ||
        contains(["ENABLED", "DISABLED"], try(var.sdp_settings.basic_config_filter_enforcement, null) != null ? var.sdp_settings.basic_config_filter_enforcement : "ENABLED")
      ) &&
      !(try(var.sdp_settings.basic_config_filter_enforcement, null) != null && try(var.sdp_settings.advanced_config, null) != null) &&
      (
        try(var.sdp_settings.advanced_config, null) == null || (
          try(var.sdp_settings.advanced_config.inspect_template, null) != null &&
          length(trimspace(try(var.sdp_settings.advanced_config.inspect_template, null) != null ? var.sdp_settings.advanced_config.inspect_template : "")) > 0 &&
          (
            try(var.sdp_settings.advanced_config.deidentify_template, null) == null ||
            length(trimspace(try(var.sdp_settings.advanced_config.deidentify_template, null) != null ? var.sdp_settings.advanced_config.deidentify_template : "x")) > 0
          )
        )
      )
    )
    error_message = "In sdp_settings, basic_config_filter_enforcement (ENABLED or DISABLED) and advanced_config are mutually exclusive, and advanced_config must specify a non-empty inspect_template (and optional non-empty deidentify_template)."
  }
}

variable "pi_and_jailbreak_filter_settings" {
  description = "Confidence level for Prompt injection and Jailbreak Filter settings (LOW_AND_ABOVE, MEDIUM_AND_ABOVE, HIGH), or DISABLED to explicitly disable the filter."
  type        = string
  default     = null

  validation {
    condition     = var.pi_and_jailbreak_filter_settings == null || contains(["LOW_AND_ABOVE", "MEDIUM_AND_ABOVE", "HIGH", "DISABLED"], var.pi_and_jailbreak_filter_settings != null ? var.pi_and_jailbreak_filter_settings : "HIGH")
    error_message = "pi_and_jailbreak_filter_settings must be one of LOW_AND_ABOVE, MEDIUM_AND_ABOVE, HIGH, DISABLED, or null."
  }
}

variable "ai_platform_floor_setting" {
  description = "Configure the AI Platform floor setting; Note: Value AI_PLATFORM must be in Integrated Services Field."
  type = object({
    inspect_only         = optional(bool)
    inspect_and_block    = optional(bool)
    enable_cloud_logging = optional(bool)
  })
  default = null

  validation {
    condition = var.ai_platform_floor_setting == null || (
      ((try(var.ai_platform_floor_setting.inspect_only, null) == true) ? 1 : 0) +
      ((try(var.ai_platform_floor_setting.inspect_and_block, null) == true) ? 1 : 0) == 1
    )
    error_message = "Exactly one of inspect_only or inspect_and_block must be set to true in ai_platform_floor_setting."
  }
}

variable "enable_multi_language_detection" {
  description = "Enable multi-language detection for floor setting. Set to null to omit floor_setting_metadata."
  type        = bool
  default     = true
}

variable "integrated_services" {
  description = "List of integrated services for which the floor setting is applicable. Possible values are AI_PLATFORM, GOOGLE_MCP_SERVER"
  type        = list(string)
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for s in var.integrated_services : contains(["AI_PLATFORM", "GOOGLE_MCP_SERVER"], s)])
    error_message = "integrated_services values must be AI_PLATFORM and/or GOOGLE_MCP_SERVER."
  }
}

variable "google_mcp_server_floor_setting" {
  description = "Configure the Google MCP Server floor setting; Note: Value GOOGLE_MCP_SERVER must be in Integrated Services Field."
  type = object({
    inspect_only         = optional(bool)
    inspect_and_block    = optional(bool)
    enable_cloud_logging = optional(bool)
  })
  default = null

  validation {
    condition = var.google_mcp_server_floor_setting == null || (
      ((try(var.google_mcp_server_floor_setting.inspect_only, null) == true) ? 1 : 0) +
      ((try(var.google_mcp_server_floor_setting.inspect_and_block, null) == true) ? 1 : 0) == 1
    )
    error_message = "Exactly one of inspect_only or inspect_and_block must be set to true in google_mcp_server_floor_setting."
  }
}
