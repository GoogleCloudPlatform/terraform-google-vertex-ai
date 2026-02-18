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

variable "display_name" {
  description = "The display name of the Reasoning Engine."
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs."
  type        = string
}

variable "region" {
  description = "The region of the reasoning engine. eg us-central1."
  type        = string
}

variable "description" {
  description = "The description of the Reasoning Engine."
  type        = string
  default     = null
}

variable "kms_key_name" {
  description = "Customer-managed encryption key name for a Reasoning Engine. If set, this Reasoning Engine and all sub-resources will be secured by this key."
  type        = string
  default     = null
}

variable "spec" {
  description = "Configurations of the Reasoning Engine."
  type = object({
    agent_framework = optional(string)
    class_methods   = optional(list(any))
    deployment_spec = optional(object({
      container_concurrency = optional(number, 9)
      env                   = optional(map(string), {})
      max_instances         = optional(number, 100)
      min_instances         = optional(number, 1)
      psc_interface_config = optional(object({
        network_attachment = optional(string)
        dns_peering_configs = optional(list(object({
          domain         = string
          target_project = string
          target_network = string
        })), [])
      }))
      resource_limits = optional(map(string))
      secret_env = optional(list(object({
        name = string
        secret_ref = object({
          secret  = string
          version = optional(string)
        })
      })), [])
    }))
    package_spec = optional(object({
      dependency_files_gcs_uri = optional(string)
      pickle_object_gcs_uri    = optional(string)
      python_version           = optional(string)
      requirements_gcs_uri     = optional(string)
    }))
    source_code_spec = optional(object({
      inline_source = optional(object({
        source_archive = optional(string)
      }))
      python_spec = optional(object({
        entrypoint_module = optional(string)
        entrypoint_object = optional(string)
        requirements_file = optional(string)
        version           = optional(string, "3.10")
      }))
      developer_connect_source = optional(object({
        config = object({
          git_repository_link = string
          dir                 = string
          revision            = string
        })
      }))
    }))
    service_account = optional(string)
  })
  default = null
}
