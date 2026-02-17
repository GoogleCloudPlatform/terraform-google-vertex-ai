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

resource "google_vertex_ai_reasoning_engine" "main" {
  display_name = var.display_name
  project      = var.project_id
  region       = var.region
  description  = var.description

  dynamic "encryption_spec" {
    for_each = (var.kms_key_name != null && var.kms_key_name != "") ? [1] : []
    content {
      kms_key_name = var.kms_key_name
    }
  }

  dynamic "spec" {
    for_each = var.spec != null ? [var.spec] : []
    content {
      agent_framework = lookup(spec.value, "agent_framework", null)
      class_methods   = lookup(spec.value, "class_methods", null) == null ? null : jsonencode(lookup(spec.value, "class_methods", null))
      service_account = lookup(spec.value, "service_account", null)

      dynamic "package_spec" {
        for_each = spec.value.package_spec == null ? [] : [spec.value.package_spec]
        content {
          dependency_files_gcs_uri = lookup(package_spec.value, "dependency_files_gcs_uri", null)
          pickle_object_gcs_uri    = lookup(package_spec.value, "pickle_object_gcs_uri", null)
          python_version           = lookup(package_spec.value, "python_version", null)
          requirements_gcs_uri     = lookup(package_spec.value, "requirements_gcs_uri", null)
        }
      }

      dynamic "deployment_spec" {
        for_each = spec.value.deployment_spec == null ? [] : [spec.value.deployment_spec]
        content {
          dynamic "env" {
            for_each = deployment_spec.value.env == null ? {} : deployment_spec.value.env
            content {
              name  = env.key
              value = env.value
            }
          }
          dynamic "secret_env" {
            for_each = deployment_spec.value.secret_env == null ? [] : deployment_spec.value.secret_env
            content {
              name = secret_env.value.name
              secret_ref {
                secret  = secret_env.value.secret_ref.secret
                version = lookup(secret_env.value.secret_ref, "version", null)
              }
            }
          }
        }
      }

      dynamic "source_code_spec" {
        for_each = lookup(spec.value, "source_code_spec", null) == null ? [] : [spec.value.source_code_spec]
        content {
          dynamic "inline_source" {
            for_each = lookup(source_code_spec.value, "inline_source", null) == null ? [] : [source_code_spec.value.inline_source]
            content {
              source_archive = lookup(inline_source.value, "source_archive", null)
            }
          }

          dynamic "python_spec" {
            for_each = lookup(source_code_spec.value, "python_spec", null) == null ? [] : [source_code_spec.value.python_spec]
            content {
              entrypoint_module = lookup(python_spec.value, "entrypoint_module", null)
              entrypoint_object = lookup(python_spec.value, "entrypoint_object", null)
              requirements_file = lookup(python_spec.value, "requirements_file", null)
              version           = lookup(python_spec.value, "version", null)
            }
          }

          dynamic "developer_connect_source" {
            for_each = lookup(source_code_spec.value, "developer_connect_source", null) == null ? [] : [source_code_spec.value.developer_connect_source]
            content {
              dynamic "config" {
                for_each = lookup(developer_connect_source.value, "config", null) == null ? [] : [developer_connect_source.value.config]
                content {
                  git_repository_link = lookup(config.value, "git_repository_link", null)
                  dir                 = lookup(config.value, "dir", null)
                  revision            = lookup(config.value, "revision", null)
                }
              }
            }
          }
        }
      }
    }
  }
}
