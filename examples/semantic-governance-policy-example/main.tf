/**
 * Copyright 2026 Google LLC
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
  region = "us-central1"
}

# A policy can only be created once the project has an active engine in the
# same region. The policy has no attribute that references the engine, so the
# ordering is declared explicitly with depends_on below.
module "semantic_governance_policy_engine" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy-engine"

  project_id = var.project_id
  region     = local.region
}

# Agent Registry lookups below filter by display name, which is not unique, so
# give each run's agent a distinct one.
resource "random_id" "suffix" {
  byte_length = 3
}

resource "google_vertex_ai_reasoning_engine" "agent" {
  project      = var.project_id
  region       = local.region
  display_name = "sgp-example-agent-${random_id.suffix.hex}"

  spec {
    identity_type = "AGENT_IDENTITY"
  }
}

# Agent Registry registers the agent asynchronously after it is created.
resource "time_sleep" "wait_for_agent_registration" {
  depends_on      = [google_vertex_ai_reasoning_engine.agent]
  create_duration = "120s"
}

data "google_agent_registry_agent" "agent" {
  project    = var.project_id
  location   = local.region
  filter     = "displayName=\"${google_vertex_ai_reasoning_engine.agent.display_name}\""
  depends_on = [time_sleep.wait_for_agent_registration]
}

module "semantic_governance_policy" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy"

  project_id                    = var.project_id
  region                        = local.region
  semantic_governance_policy_id = "no-internal-endpoints"
  natural_language_constraint   = "Do not call internal developer endpoints."
  agent                         = data.google_agent_registry_agent.agent.id
  denial_message                = "This request was blocked because it targets an internal developer endpoint."

  depends_on = [module.semantic_governance_policy_engine]
}
