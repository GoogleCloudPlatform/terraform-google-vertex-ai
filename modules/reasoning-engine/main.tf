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
  project      = var.project
  region       = var.region
  description  = var.description

  dynamic "encryption_spec" {
    for_each = var.encryption_spec != null ? [var.encryption_spec] : []
    content {
      kms_key_name = encryption_spec.value.kms_key_name
    }
  }

  dynamic "spec" {
    for_each = var.spec != null ? [var.spec] : []
    content {
      agent_framework = lookup(spec.value, "agent_framework", null)
      class_methods   = lookup(spec.value, "class_methods", null)
      service_account = lookup(spec.value, "service_account", null)

      dynamic "package_spec" {
        for_each = lookup(spec.value, "package_spec", null) != null ? [spec.value.package_spec] : []
        content {
          dependency_files_gcs_uri = lookup(package_spec.value, "dependency_files_gcs_uri", null)
          pickle_object_gcs_uri    = lookup(package_spec.value, "pickle_object_gcs_uri", null)
          python_version           = lookup(package_spec.value, "python_version", null)
          requirements_gcs_uri     = lookup(package_spec.value, "requirements_gcs_uri", null)
        }
      }

      dynamic "deployment_spec" {
        for_each = lookup(spec.value, "deployment_spec", null) != null ? [spec.value.deployment_spec] : []
        content {
          dynamic "env" {
            for_each = lookup(deployment_spec.value, "env", [])
            content {
              name  = env.value.name
              value = env.value.value
            }
          }
          dynamic "secret_env" {
            for_each = lookup(deployment_spec.value, "secret_env", [])
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
    }
  }
}
