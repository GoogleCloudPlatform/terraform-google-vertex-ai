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

variable "name" {
  description = "The name of this workbench instance"
  type        = string
}

variable "location" {
  description = "Zone in which workbench instance should be created"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "instance_owners" {
  description = "The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance"
  type        = list(string)
  default     = []
}

variable "instance_id" {
  description = "User-defined unique ID of this instance"
  type        = string
  default     = null
}

variable "labels" {
  description = "Labels to apply to this instance"
  type        = map(string)
  default     = {}
}

variable "desired_state" {
  description = "Desired state of the Workbench Instance. Set this field to ACTIVE to start the Instance, and STOPPED to stop the Instance"
  type        = string
  default     = null
}

variable "disable_proxy_access" {
  description = "If true, the workbench instance will not register with the proxy"
  type        = bool
  default     = true
}

## GCE instance configuration

variable "kms_key" {
  description = "The KMS key used to encrypt the disks, only applicable if disk_encryption is CMEK. Format: projects/{project_id}/locations/{location}/keyRings/{key_ring_id}/cryptoKeys/{key_id}"
  type        = string
}

variable "disk_encryption" {
  description = "Disk encryption method used on the boot and data disks, defaults to GMEK. Possible values are: GMEK, CMEK"
  type        = string
  default     = "CMEK"
}

variable "disable_public_ip" {
  description = "If true, no external IP will be assigned to this VM instance"
  type        = bool
  default     = true
}

variable "metadata" {
  description = "Custom metadata to apply to this instance"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "The Compute Engine tags to add to instance"
  type        = list(string)
  default     = null
}

variable "enable_ip_forwarding" {
  description = "Flag to enable ip forwarding or not, default false/off"
  type        = bool
  default     = false
}

variable "machine_type" {
  description = "The machine type of the VM instance"
  type        = string
  default     = null
}

variable "accelerator_configs" {
  description = "The hardware accelerators used on this instance. If you use accelerators, make sure that your configuration has enough vCPUs and memory to support the machine_type you have selected. Currently supports only one accelerator configuration. Possible values for type: NVIDIA_TESLA_P100, NVIDIA_TESLA_V100, NVIDIA_TESLA_P4, NVIDIA_TESLA_T4, NVIDIA_TESLA_A100, NVIDIA_A100_80GB, NVIDIA_L4, NVIDIA_TESLA_T4_VWS, NVIDIA_TESLA_P100_VWS, NVIDIA_TESLA_P4_VWS"
  type = list(object({
    type       = optional(string)
    core_count = optional(number)
  }))
  default = null
  validation {
    condition     = try(alltrue([for rp in var.accelerator_configs : contains(["NVIDIA_TESLA_P100", "NVIDIA_TESLA_V100", "NVIDIA_TESLA_P4", "NVIDIA_TESLA_T4", "NVIDIA_TESLA_A100", "NVIDIA_A100_80GB", "NVIDIA_L4", "NVIDIA_TESLA_T4_VWS", "NVIDIA_TESLA_P100_VWS", "NVIDIA_TESLA_P4_VWS"], var.accelerator_configs.type)]), false) || var.accelerator_configs == null
    error_message = "accelerator_configs.type must be one of [NVIDIA_TESLA_P100, NVIDIA_TESLA_V100, NVIDIA_TESLA_P4, NVIDIA_TESLA_T4, NVIDIA_TESLA_A100, NVIDIA_A100_80GB, NVIDIA_L4, NVIDIA_TESLA_T4_VWS, NVIDIA_TESLA_P100_VWS, NVIDIA_TESLA_P4_VWS]"
  }
}

variable "boot_disk_size_gb" {
  description = "The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). If not specified, this defaults to the recommended value of 150GB"
  type        = number
  default     = 150
}

variable "boot_disk_type" {
  description = "Indicates the type of the boot disk. Possible values are: PD_STANDARD, PD_SSD, PD_BALANCED, PD_EXTREME"
  type        = string
  default     = "PD_BALANCED"
}

variable "data_disks" {
  description = "Data disks attached to the VM instance. Currently supports only one data disk"
  type = list(object({
    disk_size_gb = optional(number, 100)
    disk_type    = optional(string, "PD_BALANCED")
  }))
  default = null
}
variable "network_interfaces" {
  description = "The network interfaces for the VM. Supports only one interface. The nic_type of vNIC to be used on this interface. This may be gVNIC or VirtioNet. Possible values are: VIRTIO_NET, GVNIC"
  type = list(object({
    network  = optional(string)
    nic_type = optional(string)
    subnet   = optional(string)
  }))
  default = null
}

variable "service_accounts" {
  description = "The service account that serves as an identity for the VM instance. Currently supports only one service account"
  type = list(object({
    email = optional(string)
  }))
  default = null
}

variable "vm_image" {
  description = "Definition of a custom Compute Engine virtual machine image for starting a workbench instance with the environment installed directly on the VM"
  type = object({
    family  = optional(string)
    name    = optional(string)
    project = optional(string)
  })
  default = null
}
