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

module "common_vertex_ai_workbench" {
  source               = "../../modules/workbench/"
  name                 = var.name
  location             = var.location
  project_id           = var.project_id
  instance_owners      = var.instance_owners
  instance_id          = var.instance_id
  labels               = var.labels
  desired_state        = var.desired_state
  disable_proxy_access = var.disable_proxy_access
  kms_key              = var.kms_key
  disk_encryption      = var.disk_encryption
  disable_public_ip    = var.disable_public_ip
  metadata             = var.metadata
  tags                 = var.tags
  enable_ip_forwarding = var.enable_ip_forwarding
  machine_type         = var.machine_type
  accelerator_configs  = var.accelerator_configs
  boot_disk_size_gb    = var.boot_disk_size_gb
  boot_disk_type       = var.boot_disk_type
  data_disks           = var.data_disks
  network_interfaces   = var.network_interfaces
  service_accounts     = var.service_accounts
  vm_image             = var.vm_image
  bucket_prefix        = var.bucket_prefix
  bucket_location      = var.bucket_location
  bucket_storage_class = var.bucket_storage_class
  bucket_versioning    = var.bucket_versioning
  byod_access_group    = var.byod_access_group
  bucket_timestamp     = var.bucket_timestamp
}
