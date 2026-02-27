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
  type        = string
  default     = null
  description = "The ID of project to create the floor settings in. Note: Project id must be set if Parent type is project."
}

variable "folder_id" {
  type        = string
  default     = null
  description = "The ID of folder to create the floor settings in. Note: Folder id must be set if Parent type is folder."
}

variable "org_id" {
  type        = string
  default     = null
  description = "The ID of organization to create the floor settings in. Note: Org id must be set if Parent type if organization."
}

variable "parent_type" {
  type        = string
  description = "Parent type. Can be organization, folder, or project to create the floor settings in"
  validation {
    condition     = contains(["organization", "folder", "project"], var.parent_type)
    error_message = "parent_type must be one of organization, folder, project"
  }
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
  description = "Configure the AI Platform floor setting; Note: Value AI_PLATFORM must be in Integrated Services Field."
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
  description = "List of integrated services for which the floor setting is applicable. Possible values are AI_PLATFORM, GOOGLE_MCP_SERVER"
  type        = list(string)
  default     = []
}

variable "google_mcp_server_floor_setting" {
  description = "Configure the Google MCP Server floor setting; Note: Value GOOGLE_MCP_SERVER must be in Integrated Services Field."
  type = object({
    inspect_only         = optional(bool)
    inspect_and_block    = optional(bool)
    enable_cloud_logging = optional(bool)
  })
  default = null
}
