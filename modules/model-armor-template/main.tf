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

resource "google_model_armor_template" "model_armor_template" {
  location    = var.location
  project     = var.project_id
  template_id = var.template_id

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


  dynamic "template_metadata" {
    for_each = var.metadata_configs == null ? [] : ["template_metadata"]
    content {
      custom_llm_response_safety_error_message = lookup(var.metadata_configs, "custom_llm_response_safety_error_message")
      custom_llm_response_safety_error_code    = lookup(var.metadata_configs, "custom_llm_response_safety_error_code")
      log_sanitize_operations                  = lookup(var.metadata_configs, "log_sanitize_operations")
      log_template_operations                  = lookup(var.metadata_configs, "log_template_operations")
      ignore_partial_invocation_failures       = lookup(var.metadata_configs, "ignore_partial_invocation_failures")
      custom_prompt_safety_error_code          = lookup(var.metadata_configs, "custom_prompt_safety_error_code")
      custom_prompt_safety_error_message       = lookup(var.metadata_configs, "custom_prompt_safety_error_message")
      enforcement_type                         = lookup(var.metadata_configs, "enforcement_type")
      dynamic "multi_language_detection" {
        for_each = lookup(var.metadata_configs, "enable_multi_language_detection") == null ? [] : ["multi_language_detection"]
        content {
          enable_multi_language_detection = lookup(var.metadata_configs, "enable_multi_language_detection")
        }
      }
    }
  }

  labels = var.labels
}


