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

# Customer-VPC networking that the PSC gateway attaches to. A gateway_configs
# entry must reference an existing network, subnetwork, and private DNS zone
# together (the engine rejects a partial set), so this example creates all three.

resource "google_compute_network" "agent_network" {
  project                 = var.project_id
  name                    = "agent-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "agent_subnet" {
  project       = var.project_id
  name          = "agent-subnet"
  region        = "us-central1"
  network       = google_compute_network.agent_network.id
  ip_cidr_range = "10.0.0.0/24"
}

# Private zone into which the engine publishes the gateway's A-record.
resource "google_dns_managed_zone" "sgp_private_zone" {
  project     = var.project_id
  name        = "sgp-private-zone"
  dns_name    = "internal.sgp.local."
  description = "Private zone for Semantic Governance Policy Engine gateway A-records."
  visibility  = "private"

  private_visibility_config {
    networks {
      network_url = google_compute_network.agent_network.id
    }
  }
}

module "semantic_governance_policy_engine" {
  source = "GoogleCloudPlatform/vertex-ai/google//modules/semantic-governance-policy-engine"

  project_id = var.project_id
  region     = "us-central1"

  # One customer-VPC PSC gateway. network/subnetwork are passed as their full
  # resource URIs (the resources' .id, e.g. projects/P/global/networks/N -- not
  # .self_link, which is the https:// form the API rejects) so the config matches
  # what the API stores and the gateway does not churn on subsequent plans.
  gateway_configs = {
    "agent-gateway" = {
      network       = google_compute_network.agent_network.id
      subnetwork    = google_compute_subnetwork.agent_subnet.id
      dns_zone_name = google_dns_managed_zone.sgp_private_zone.name
    }
  }
}
