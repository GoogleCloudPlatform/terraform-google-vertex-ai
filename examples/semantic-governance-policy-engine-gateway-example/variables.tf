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

variable "project_id" {
  description = "The ID of the project in which the resources belong."
  type        = string
}

variable "region" {
  description = "The region in which to provision the engine and the gateway's subnetwork."
  type        = string
  default     = "us-central1"
}

variable "network_name" {
  description = "Name of the VPC network the PSC gateway attaches to."
  type        = string
  default     = "agent-network"
}

variable "subnetwork_name" {
  description = "Name of the subnetwork the PSC gateway attaches to."
  type        = string
  default     = "agent-subnet"
}

variable "subnetwork_cidr" {
  description = "Primary IPv4 CIDR range for the subnetwork."
  type        = string
  default     = "10.0.0.0/24"
}

variable "dns_zone_name" {
  description = "Name of the private Cloud DNS managed zone the engine publishes the gateway's A-record into."
  type        = string
  default     = "sgp-private-zone"
}

variable "dns_name" {
  description = "DNS suffix for the private managed zone (must be a fully-qualified name ending in a dot)."
  type        = string
  default     = "internal.sgp.local."
}

variable "gateway_name" {
  description = "Name of the PSC gateway (used as the key in the engine's gateway_configs map)."
  type        = string
  default     = "agent-gateway"
}
