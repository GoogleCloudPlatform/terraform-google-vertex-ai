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

module "agent_engine" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/agent-engine"

  project_id   = var.project_id
  display_name = "Vertex AI Agent Engine"
  region       = "us-central1"
  description  = "Agent Engine example"
  spec = {
    source_code_spec = {
      developer_connect_source = {
        config = {
          # Users will provide this via tfvars
          git_repository_link = var.git_repository_link
          # Directory inside the git repo where the code lives
          dir      = var.git_repository_dir
          revision = "main"
        }
      }
      python_spec = {
        entrypoint_module = "agent"
        entrypoint_object = "agent_instance"
        requirements_file = "requirements.txt"
        version           = "3.11"
      }
    }
  }
}
