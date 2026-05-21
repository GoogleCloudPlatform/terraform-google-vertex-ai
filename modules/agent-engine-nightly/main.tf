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
        source_archive = "H4sIAAAAAAAAA+2VXW+bMBSGuV1+hcVVKg0DSQAJKdK6Le0qdWmlaRfVNEUenBAawNQ2UdKq/30mhKXdh7KL0WrqeW6MP8+xX16b2kbnOJrA8+rSDTznYdliuN7AGfqO4/uu4bgD33UM4nWfmmFUUjFBiBGzVG7K5YJfs9+OO9T/n0Lt0+nnnC1hnmbQUYxaYH80+qP+A3envxcEw2Gg9R/5gdbf6SifR7x0/S8/XEyvQsKyjJQsWrIEej1dCfe13UfYewXFiry7uLw6OTufzN6ffTp+ez4Zu6Q+QCu6Xc0JpXYey5keXaiZFBHVXTS5JTkoFjPFmh5aboiAmyoVkOuqpGqtnvscXirUbiXpLsYh//tesPe/N6j9P3QG6P+nIMqYlOTjzp/H9b8Q9nqExDAnNxWITV9CNj8KdRMhaV5yobbeBanktq0SGRkTc6FUGdp2a3SacJ5kQNNCgShYZkc8LysFbSB75dql4NcQKbuochBpZO3qVhqb25WV2DRhawTIkhcSdKw2PE1A9XX412QBLAYhx3dmu751krEVF2ZIzNNtJub90S9rUaE1hdmci5n+CVQl+w/HqEoUZG5KEKs0AuvuxywFa3X/pm4HkYGUluDfuKrTj2nKcprsprAo4pW2lt56syFYR1AqMtkWKS/Cn6NNeaHvW8G5ai5KvdlHyvSP/rn+1O7+Jj7kf2fk7/3vD7X/fdfF9/9JaHxqRRmvYoulZcaU9kP+pXnCoUjSAuTX584SQRAEQRAEQRAEQRAEQRAEQRAEQZC/4TsjV0RZACgAAA=="
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
