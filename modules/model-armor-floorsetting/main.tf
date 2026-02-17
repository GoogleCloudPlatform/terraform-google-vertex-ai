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
  # Maps the type to the actual ID provided
  parent_id_map = {
    "project"      = var.project_id
    "folder"       = var.folder_id
    "organization" = var.org_id
  }

  # Constructs the string: e.g., "projects/my-project-id" or "folders/12345"
  # Note: Model Armor uses "projects/", "folders/", or "organizations/" (plural)
  parent_path = "${var.parent_type}s/${local.parent_id_map[var.parent_type]}"
}

resource "google_model_armor_floorsetting" "model_armor_floorsetting" {
  location                         = "global"
  parent                           = local.parent_path
  enable_floor_setting_enforcement = var.enable_floor_setting_enforcement
  integrated_services              = var.integrated_services

  filter_config {

    # Responsible AI filters
    dynamic "rai_settings" {
      for_each = var.rai_filters == null ? [] : ["rai_settings"]
      content {

        dynamic "rai_filters" {
          for_each = lookup(var.rai_filters, "dangerous") == null ? [] : ["dangerous"]
          content {
            filter_type      = "DANGEROUS"
            confidence_level = lookup(var.rai_filters, "dangerous")
          }
        }

        dynamic "rai_filters" {
          for_each = lookup(var.rai_filters, "sexually_explicit") == null ? [] : ["sexually_explicit"]
          content {
            filter_type      = "SEXUALLY_EXPLICIT"
            confidence_level = lookup(var.rai_filters, "sexually_explicit")
          }
        }

        dynamic "rai_filters" {
          for_each = lookup(var.rai_filters, "hate_speech") == null ? [] : ["hate_speech"]
          content {
            filter_type      = "HATE_SPEECH"
            confidence_level = lookup(var.rai_filters, "hate_speech")
          }
        }

        dynamic "rai_filters" {
          for_each = lookup(var.rai_filters, "harassment") == null ? [] : ["harassment"]
          content {
            filter_type      = "HARASSMENT"
            confidence_level = lookup(var.rai_filters, "harassment")
          }
        }

      }
    }

    # Sensitive data protection filters
    dynamic "sdp_settings" {
      for_each = var.sdp_settings == null ? [] : ["sdp_settings"]
      content {
        dynamic "basic_config" {
          for_each = lookup(var.sdp_settings, "basic_config_filter_enforcement") == true && try(var.sdp_settings.advanced_config, null) == null ? ["basic_config"] : []
          content {
            filter_enforcement = "ENABLED"
          }
        }
        dynamic "advanced_config" {
          for_each = try(var.sdp_settings.advanced_config, null) == null ? [] : ["advanced_config"]
          content {
            inspect_template    = lookup(var.sdp_settings.advanced_config, "inspect_template")
            deidentify_template = lookup(var.sdp_settings.advanced_config, "deidentify_template")
          }
        }
      }
    }

    # Prompt injection and jailbreak filters
    dynamic "pi_and_jailbreak_filter_settings" {
      for_each = var.pi_and_jailbreak_filter_settings == null ? [] : ["pi_and_jailbreak_filter_settings"]
      content {
        filter_enforcement = "ENABLED"
        confidence_level   = var.pi_and_jailbreak_filter_settings
      }
    }

    # Malicious URI filter settings
    dynamic "malicious_uri_filter_settings" {
      for_each = var.enable_malicious_uri_filter_settings ? ["malicious_uri_filter_settings"] : []
      content {
        filter_enforcement = "ENABLED"
      }
    }

  }


  floor_setting_metadata {
    multi_language_detection {
      enable_multi_language_detection = var.enable_multi_language_detection
    }
  }

  dynamic "ai_platform_floor_setting" {
    for_each = var.ai_platform_floor_setting == null ? [] : ["ai_platform_floor_setting"]
    content {
      inspect_only         = lookup(var.ai_platform_floor_setting, "inspect_only")
      inspect_and_block    = lookup(var.ai_platform_floor_setting, "inspect_and_block")
      enable_cloud_logging = lookup(var.ai_platform_floor_setting, "enable_cloud_logging")
    }
  }

  dynamic "google_mcp_server_floor_setting" {
    for_each = var.google_mcp_server_floor_setting == null ? [] : ["google_mcp_server_floor_setting"]
    content {
      inspect_only         = lookup(var.google_mcp_server_floor_setting, "inspect_only")
      inspect_and_block    = lookup(var.google_mcp_server_floor_setting, "inspect_and_block")
      enable_cloud_logging = lookup(var.google_mcp_server_floor_setting, "enable_cloud_logging")
    }
  }

  lifecycle {
    precondition {
      condition = (
        (var.parent_type == "project"      && var.project_id != null) ||
        (var.parent_type == "folder"       && var.folder_id != null) ||
        (var.parent_type == "organization" && var.org_id != null)
      )
      error_message = "The ID variable corresponding to the selected parent_type must not be null."
    }
  }
}
