/**
 * Copyright 2023 Google LLC
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

resource "random_id" "suffix" {
  byte_length = 4
}

data "google_netblock_ip_ranges" "iap_forwarders" {
  range_type = "iap-forwarders"
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 12.0"
  project_id   = var.project_id
  network_name = "complete-workbench"
  mtu          = 1460
  subnets = [
    {
      subnet_name           = "complete-subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = "us-central1"
      subnet_private_access = true
    },
  ]
  ingress_rules = [
    {
      name          = "allow-ssh-from-iap"
      description   = "Allow all traffic from IAP"
      ranges        = null
      source_ranges = concat(data.google_netblock_ip_ranges.iap_forwarders.cidr_blocks_ipv4)
      allow = [{
        protocol = "tcp"
        ports    = ["22"]
      }]
    },
  ]
}

module "cloud_router" {
  source  = "terraform-google-modules/cloud-router/google"
  version = "~> 8.0"

  name    = "test-ca-us-central1-cr"
  project = var.project_id
  region  = "us-central1"
  network = module.test-vpc-module.network_self_link
  nats = [
    {
      name                               = "test-ca-us-central1-nat"
      source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
      min_ports_per_vm                   = 4096
      log_config = {
        "filter" = "ERRORS_ONLY"
      }
    },
  ]
}
