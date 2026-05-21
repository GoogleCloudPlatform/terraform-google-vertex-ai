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
  is_container_spec_deployment = var.spec != null && lookup(var.spec, "container_spec", null) != null
  identity_type                = lookup(var.spec, "identity_type", "SERVICE_ACCOUNT")

  identity_prefixes = {
    "SERVICE_ACCOUNT" = "serviceAccount:"
    "AGENT_IDENTITY"  = "principal://"
  }

  member_prefix = lookup(local.identity_prefixes, local.identity_type, "")
}

resource "random_id" "suffix" {
  count       = local.is_container_spec_deployment ? 1 : 0
  byte_length = 4
}

resource "google_vertex_ai_reasoning_engine" "tenant_mds" {
  count        = local.is_container_spec_deployment ? 1 : 0
  provider     = google-nightly
  display_name = "${var.display_name}-mds-${random_id.suffix[0].hex}"
  description  = "Metadata agent to get tenant project service account"
  region       = var.region
  project      = var.project_id

  spec {
    source_code_spec {
      inline_source {
        source_archive = "H4sIAAAAAAAAA+2WUW/bNhDH/axPcVBeGsCWLTt2gA0OoKXZZtRwgDhd0SeDkc4yF4rkSKqKv32Pkusk3Yo+dFlRjL8XWeTp+Ofd8ehk2HtxRsT5dOqf6fl09PT5iV46HY8m09lscpb2Rul4ls56MH15ab1ebR0zAL2CcbvX9zv1J/tHu6/N/6AkQ1aidInev9waPsGzs7Mv5X9MxXHMPz0o/2fj87QHo5eT9Mj/PP8ncKn03vBy52A8Gs/gN6VKgbBcXkYn0QkseY7SYgG1LNCA2yFkmuX0OMz04Q80lisJ42QEr7xBfJiKT38mD3tVQ8X2IJWD2iK54Ba2nNbAhxy1Ay4hV5UWnMkcoeFu1y5zcJKQi/cHF+rOMbJmZK/pbfvUDphrBbfsnNM/DYdN0ySsVZsoUw5FZ2mHy8Xl1Wp9NSDF7TdvpUBrweBfNTe017s9ME2CcnZHMgVrQBlgpUGac8oLbgx3XJZ9sGrrGmaQvBTcOsPvavcsWp/k0aafGlC8mIQ4W8NiHcMv2Xqx7pOPd4vb36/f3sK77OYmW90urtZwfQOX16vXi9vF9YrefoVs9R7eLFav+4AUK1oGH7Tx+kkk93HEwgdtjfhMwFZ1gqzGnG95TvuSZU2nH0r1AY2k7YBGU3Hrs2lJXkFeBK+4Y64d+dumkijaGlWRA18zCSvuk7abWK9DGQdLUWV+oDOjVRw+MN4ZbVCWXOLRNivuM62jKLJ+E7gRotq0hjA/+nkV+exKVuE8PpgxkktHWLq4305WqkAxj0usuOSU4elAG3WYK9Dmhmu/m3mcQeeB0unQsNzxD1RE7YI+VPSDRgWVmiTdtg1BcvDDJSWyzls/nSRP7MuUSoHqc4dCb2vRh63hKAux7/twwr1UjcCixLausgUcxScQP/p5g6j9saGak7ahxSEXyEzfa8m5P3LeWYNCDDodNRVt0jk4jU6jyCjljrHr4trJbMfmnwe42xRV/KaLbLXfOLSufTvsGKWXvHEUJ6qT+a2psR+dfu/mFfhmkuGh61X+3Cbuwf37a3zl/h+NJ5///5v5vwTh/v8P6Fr3gFr3xTxNJmmSRoehXKi6GDCuBXPUECs/n05GdGU+M7BOGeoiF/NJ8mSO2grj/ovp4xir3e5iPk7GZBkpTfWGgsrOmf2AbjC6AtAMylwPfJPB7x2XQCAQCAQCgUAgEAgEAoFAIBAIBAKBQOBH5CP09wMCACgAAA=="
      }

      python_spec {
        entrypoint_module = "agent"
        entrypoint_object = "root_agent"
      }
    }
  }
}

data "google_vertex_ai_reasoning_engine_query" "tenant_mds" {
  count               = local.is_container_spec_deployment ? 1 : 0
  provider            = google-nightly
  project             = var.project_id
  region              = var.region
  reasoning_engine_id = google_vertex_ai_reasoning_engine.tenant_mds[0].name
  depends_on          = [google_vertex_ai_reasoning_engine.tenant_mds]
}

resource "google_project_iam_member" "vertex_ar_reader" {
  count      = local.is_container_spec_deployment ? 1 : 0
  project    = data.google_project.project.project_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:service-${data.google_project.project.number}@gcp-sa-aiplatform-re.iam.gserviceaccount.com"
  depends_on = [data.google_vertex_ai_reasoning_engine_query.tenant_mds]
}

resource "google_project_iam_member" "tenant_ar_reader" {
  count   = local.is_container_spec_deployment ? 1 : 0
  project = data.google_project.project.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${jsondecode(data.google_vertex_ai_reasoning_engine_query.tenant_mds[0].output).output}"
}

resource "google_vertex_ai_reasoning_engine" "main" {
  provider     = google-nightly
  display_name = var.display_name
  project      = var.project_id
  region       = var.region
  description  = var.description

  depends_on = [
    google_project_iam_member.aiplatform_roles,
    var.module_depends_on,
    google_project_iam_member.vertex_ar_reader,
    google_project_iam_member.tenant_ar_reader
  ]

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
      identity_type   = lookup(spec.value, "identity_type", null)

      dynamic "package_spec" {
        for_each = lookup(spec.value, "package_spec", null) == null ? [] : [spec.value.package_spec]
        content {
          dependency_files_gcs_uri = lookup(package_spec.value, "dependency_files_gcs_uri", null)
          pickle_object_gcs_uri    = lookup(package_spec.value, "pickle_object_gcs_uri", null)
          python_version           = lookup(package_spec.value, "python_version", null)
          requirements_gcs_uri     = lookup(package_spec.value, "requirements_gcs_uri", null)
        }
      }

      dynamic "container_spec" {
        for_each = lookup(spec.value, "container_spec", null) == null ? [] : [spec.value.container_spec]
        content {
          image_uri = lookup(container_spec.value, "image_uri", null)
        }
      }

      dynamic "deployment_spec" {
        for_each = lookup(spec.value, "deployment_spec", null) == null ? [] : [spec.value.deployment_spec]
        content {
          container_concurrency = lookup(deployment_spec.value, "container_concurrency", null)
          max_instances         = lookup(deployment_spec.value, "max_instances", null)
          min_instances         = lookup(deployment_spec.value, "min_instances", null)
          resource_limits       = lookup(deployment_spec.value, "resource_limits", null)

          dynamic "env" {
            for_each = lookup(deployment_spec.value, "env", {})
            content {
              name  = env.key
              value = env.value
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

          dynamic "psc_interface_config" {
            for_each = lookup(deployment_spec.value, "psc_interface_config", null) == null ? [] : [deployment_spec.value.psc_interface_config]
            content {
              network_attachment = lookup(psc_interface_config.value, "network_attachment", null)
              dynamic "dns_peering_configs" {
                for_each = lookup(psc_interface_config.value, "dns_peering_configs", [])
                content {
                  domain         = dns_peering_configs.value.domain
                  target_project = dns_peering_configs.value.target_project
                  target_network = dns_peering_configs.value.target_network
                }
              }
            }
          }

          dynamic "agent_gateway_config" {
            for_each = length(var.google_managed_agent_gateway_config) > 0 ? [1] : []
            content {

              dynamic "client_to_agent_config" {
                for_each = [for c in var.google_managed_agent_gateway_config : c if c.gateway_type == "CLIENT_TO_AGENT"]
                content {
                  agent_gateway = client_to_agent_config.value.gateway_id
                }
              }

              dynamic "agent_to_anywhere_config" {
                for_each = [for c in var.google_managed_agent_gateway_config : c if c.gateway_type == "AGENT_TO_ANYWHERE"]
                content {
                  agent_gateway = agent_to_anywhere_config.value.gateway_id
                }
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

          dynamic "image_spec" {
            for_each = lookup(source_code_spec.value, "image_spec", null) == null ? [] : [source_code_spec.value.image_spec]
            content {
              build_args = lookup(image_spec.value, "build_args", null)
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

resource "google_project_service_identity" "aiplatform_identity" {
  provider = google-beta
  project  = var.project_id
  service  = "aiplatform.googleapis.com"
}

# Assign the Custom Role to the Vertex AI Service Identity
resource "google_project_iam_member" "aiplatform_roles" {
  for_each = toset(var.service_account_roles)
  project  = var.project_id
  role     = each.value
  member   = google_project_service_identity.aiplatform_identity.member
}

# Assign roles to the Reasoning Engine's effective identity
resource "google_project_iam_member" "reasoning_engine_effective_identity_roles" {
  for_each = toset(var.effective_identity_roles)
  project  = var.project_id
  role     = each.value
  member   = "${local.member_prefix}${google_vertex_ai_reasoning_engine.main.spec[0].effective_identity}"
}

data "google_project" "project" {
  project_id = var.project_id
}
