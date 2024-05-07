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
 * limitations unddisk_size_gber the License.
 */

resource "google_workbench_instance" "vertex_ai_workbench" {

  disable_proxy_access = var.disable_proxy_access
  instance_id          = var.instance_id
  instance_owners      = var.instance_owners
  labels               = var.labels
  location             = var.location
  name                 = var.name
  project              = var.project_id
  desired_state        = var.desired_state

  gce_setup {
    disable_public_ip    = var.disable_public_ip
    enable_ip_forwarding = var.enable_ip_forwarding
    machine_type         = var.machine_type
    metadata             = merge(var.metadata_configs, var.metadata)
    tags                 = var.tags

    dynamic "accelerator_configs" {
      for_each = var.accelerator_configs == null ? [] : var.accelerator_configs
      iterator = accelerator_config
      content {
        type       = accelerator_config.value.type
        core_count = accelerator_config.value.core_count
      }
    }

    boot_disk {
      disk_encryption = var.disk_encryption
      kms_key         = var.kms_key
      disk_size_gb    = var.boot_disk_size_gb
      disk_type       = var.boot_disk_type
    }

    dynamic "data_disks" {
      for_each = var.data_disks == null ? [] : var.data_disks
      iterator = data_disk
      content {
        disk_encryption = var.disk_encryption
        kms_key         = var.kms_key
        disk_size_gb    = data_disk.value.disk_size_gb
        disk_type       = data_disk.value.disk_type
      }
    }

    dynamic "network_interfaces" {
      for_each = var.network_interfaces == null ? [] : var.network_interfaces
      iterator = network_interface
      content {
        network  = network_interface.value.network
        nic_type = network_interface.value.nic_type
        subnet   = network_interface.value.subnet
      }
    }

    dynamic "service_accounts" {
      for_each = var.service_accounts == null ? [] : var.service_accounts
      iterator = service_account
      content {
        email = service_account.value.email
      }
    }

    dynamic "vm_image" {
      for_each = var.vm_image == null ? [] : ["vm_image"]
      content {
        family  = var.vm_image.family
        name    = var.vm_image.name
        project = var.vm_image.project
      }
    }

    dynamic "container_image" {
      for_each = var.container_image == null ? [] : ["container_image"]
      content {
        repository = lookup(var.container_image, "repository", null)
        tag        = lookup(var.container_image, "tag", null)
      }
    }

    dynamic "shielded_instance_config" {
      for_each = var.shielded_instance_config == null ? [] : ["shielded_instance_config"]
      content {
        enable_secure_boot          = lookup(var.shielded_instance_config, "enable_secure_boot", null)
        enable_vtpm                 = lookup(var.shielded_instance_config, "enable_vtpm", null)
        enable_integrity_monitoring = lookup(var.shielded_instance_config, "enable_integrity_monitoring", null)
      }
    }

  }
}
