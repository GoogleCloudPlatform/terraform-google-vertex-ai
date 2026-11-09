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

locals {
  # Determine parent_type based on which variable is provided (Project > Folder > Organization)
  parent_type = var.project_id != null ? "project" : (var.folder_id != null ? "folder" : "organization")

  # Select the first non-null ID
  parent_id = coalesce(var.project_id, var.folder_id, var.org_id, "undefined")

  # Construct the full parent path
  parent_path = "${local.parent_type}s/${local.parent_id}"

  effective_rai_filters = var.rai_filters == null ? [] : [
    for item in [
      { filter_type = "DANGEROUS", confidence_level = var.rai_filters.dangerous },
      { filter_type = "SEXUALLY_EXPLICIT", confidence_level = var.rai_filters.sexually_explicit },
      { filter_type = "HATE_SPEECH", confidence_level = var.rai_filters.hate_speech },
      { filter_type = "HARASSMENT", confidence_level = var.rai_filters.harassment },
    ] : item if item.confidence_level != null
  ]

  has_sdp_advanced = try(var.sdp_settings.advanced_config, null) != null && (
    try(var.sdp_settings.advanced_config.inspect_template, null) != null ||
    try(var.sdp_settings.advanced_config.deidentify_template, null) != null
  )
  has_sdp_settings = try(var.sdp_settings.basic_config_filter_enforcement, null) != null || local.has_sdp_advanced
}

resource "google_model_armor_floorsetting" "model_armor_floorsetting" {
  location                         = "global"
  parent                           = local.parent_path
  enable_floor_setting_enforcement = var.enable_floor_setting_enforcement
  integrated_services              = var.integrated_services

  filter_config {

    # Responsible AI filters
    dynamic "rai_settings" {
      for_each = length(local.effective_rai_filters) > 0 ? ["rai_settings"] : []
      content {
        dynamic "rai_filters" {
          for_each = local.effective_rai_filters
          content {
            filter_type      = rai_filters.value.filter_type
            confidence_level = rai_filters.value.confidence_level
          }
        }
      }
    }

    # Sensitive data protection filters
    dynamic "sdp_settings" {
      for_each = local.has_sdp_settings ? ["sdp_settings"] : []
      content {
        dynamic "basic_config" {
          for_each = try(var.sdp_settings.basic_config_filter_enforcement, null) == null ? [] : ["basic_config"]
          content {
            filter_enforcement = var.sdp_settings.basic_config_filter_enforcement
          }
        }
        dynamic "advanced_config" {
          for_each = local.has_sdp_advanced ? ["advanced_config"] : []
          content {
            inspect_template    = var.sdp_settings.advanced_config.inspect_template
            deidentify_template = var.sdp_settings.advanced_config.deidentify_template
          }
        }
      }
    }

    # Prompt injection and jailbreak filters
    dynamic "pi_and_jailbreak_filter_settings" {
      for_each = var.pi_and_jailbreak_filter_settings == null ? [] : ["pi_and_jailbreak_filter_settings"]
      content {
        filter_enforcement = var.pi_and_jailbreak_filter_settings == "DISABLED" ? "DISABLED" : "ENABLED"
        confidence_level   = var.pi_and_jailbreak_filter_settings == "DISABLED" ? null : var.pi_and_jailbreak_filter_settings
      }
    }

    # Malicious URI filter settings
    dynamic "malicious_uri_filter_settings" {
      for_each = var.malicious_uri_filter_settings == null ? [] : ["malicious_uri_filter_settings"]
      content {
        filter_enforcement = var.malicious_uri_filter_settings
      }
    }

  }


  dynamic "floor_setting_metadata" {
    for_each = var.enable_multi_language_detection == null ? [] : ["floor_setting_metadata"]
    content {
      multi_language_detection {
        enable_multi_language_detection = var.enable_multi_language_detection
      }
    }
  }

  dynamic "ai_platform_floor_setting" {
    for_each = var.ai_platform_floor_setting == null ? [] : ["ai_platform_floor_setting"]
    content {
      inspect_only         = var.ai_platform_floor_setting.inspect_only == true ? true : null
      inspect_and_block    = var.ai_platform_floor_setting.inspect_and_block == true ? true : null
      enable_cloud_logging = var.ai_platform_floor_setting.enable_cloud_logging
    }
  }

  dynamic "google_mcp_server_floor_setting" {
    for_each = var.google_mcp_server_floor_setting == null ? [] : ["google_mcp_server_floor_setting"]
    content {
      inspect_only         = var.google_mcp_server_floor_setting.inspect_only == true ? true : null
      inspect_and_block    = var.google_mcp_server_floor_setting.inspect_and_block == true ? true : null
      enable_cloud_logging = var.google_mcp_server_floor_setting.enable_cloud_logging
    }
  }

  lifecycle {
    precondition {
      condition     = (var.project_id != null ? 1 : 0) + (var.folder_id != null ? 1 : 0) + (var.org_id != null ? 1 : 0) == 1
      error_message = "Exactly one of project_id, folder_id, or org_id must be provided to determine the parent resource."
    }
  }
}
