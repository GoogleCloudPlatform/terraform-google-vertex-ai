Copyright 2023 Google LLC

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

     http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

# Module for Vertex AI Workbench Instance

This module is used to create Vertex AI Workbench Instance. You can find example(s) for this module [here](./examples/)

```hcl
module "simple_vertex_ai_workbench" {
  name                 = "test-vertex-ai-instance"
  location             = local.location
  project_id           = var.project_id
  instance_owners      = ["${var.instance_owner}"] # This principal requires Service Account User IAM role
  labels               = local.labels
  disable_proxy_access = true
  kms_key              = module.kms.keys["test"]

  machine_type         = "e2-standard-2"
  disable_public_ip    = true
  enable_ip_forwarding = false
  tags                 = ["abc", "def"]

  service_accounts = [
    {
      email = "${google_service_account.workbench_sa.email}"
    },
  ]

  data_disks = [
    {
      disk_size_gb = 330
      disk_type    = "PD_BALANCED" #PD_STANDARD, PD_SSD, PD_BALANCED, PD_EXTREME
    },
  ]

  network_interfaces = [
    {
      network  = module.test-vpc-module.network_id
      subnet   = module.test-vpc-module.subnets_ids[0]
      nic_type = "GVNIC"
    }
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerator\_configs | The hardware accelerators used on this instance. If you use accelerators, make sure that your configuration has enough vCPUs and memory to support the machine\_type you have selected. Currently supports only one accelerator configuration. Possible values for type: NVIDIA\_TESLA\_P100, NVIDIA\_TESLA\_V100, NVIDIA\_TESLA\_P4, NVIDIA\_TESLA\_T4, NVIDIA\_TESLA\_A100, NVIDIA\_A100\_80GB, NVIDIA\_L4, NVIDIA\_TESLA\_T4\_VWS, NVIDIA\_TESLA\_P100\_VWS, NVIDIA\_TESLA\_P4\_VWS | <pre>list(object({<br>    type       = optional(string)<br>    core_count = optional(number)<br>  }))</pre> | `null` | no |
| boot\_disk\_size\_gb | The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). If not specified, this defaults to the recommended value of 150GB | `number` | `150` | no |
| boot\_disk\_type | Indicates the type of the boot disk. Possible values are: PD\_STANDARD, PD\_SSD, PD\_BALANCED, PD\_EXTREME | `string` | `"PD_BALANCED"` | no |
| data\_disks | Data disks attached to the VM instance. Currently supports only one data disk | <pre>list(object({<br>    disk_size_gb = optional(number, 100)<br>    disk_type    = optional(string, "PD_BALANCED")<br>  }))</pre> | `null` | no |
| desired\_state | Desired state of the Workbench Instance. Set this field to ACTIVE to start the Instance, and STOPPED to stop the Instance | `string` | `null` | no |
| disable\_proxy\_access | If true, the workbench instance will not register with the proxy | `bool` | `true` | no |
| disable\_public\_ip | If true, no external IP will be assigned to this VM instance | `bool` | `true` | no |
| disk\_encryption | Disk encryption method used on the boot and data disks, defaults to GMEK. Possible values are: GMEK, CMEK | `string` | `"CMEK"` | no |
| enable\_ip\_forwarding | Flag to enable ip forwarding or not, default false/off | `bool` | `false` | no |
| instance\_id | User-defined unique ID of this instance | `string` | `null` | no |
| instance\_owners | The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance | `list(string)` | `[]` | no |
| kms\_key | The KMS key used to encrypt the disks, only applicable if disk\_encryption is CMEK. Format: projects/{project\_id}/locations/{location}/keyRings/{key\_ring\_id}/cryptoKeys/{key\_id} | `string` | n/a | yes |
| labels | Labels to apply to this instance | `map(string)` | `{}` | no |
| location | Zone in which workbench instance should be created | `string` | n/a | yes |
| machine\_type | The machine type of the VM instance | `string` | `null` | no |
| metadata | Custom metadata to apply to this instance | `map(string)` | `{}` | no |
| name | The name of this workbench instance | `string` | n/a | yes |
| network\_interfaces | The network interfaces for the VM. Supports only one interface. The nic\_type of vNIC to be used on this interface. This may be gVNIC or VirtioNet. Possible values are: VIRTIO\_NET, GVNIC | <pre>list(object({<br>    network  = optional(string)<br>    nic_type = optional(string)<br>    subnet   = optional(string)<br>  }))</pre> | `null` | no |
| project\_id | The ID of the project in which the resource belongs | `string` | n/a | yes |
| service\_accounts | The service account that serves as an identity for the VM instance. Currently supports only one service account | <pre>list(object({<br>    email = optional(string)<br>  }))</pre> | `null` | no |
| tags | The Compute Engine tags to add to instance | `list(string)` | `null` | no |
| vm\_image | Definition of a custom Compute Engine virtual machine image for starting a workbench instance with the environment installed directly on the VM | <pre>object({<br>    family  = optional(string)<br>    name    = optional(string)<br>    project = optional(string)<br>  })</pre> | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| creator | Email address of entity that sent original CreateInstance request. |
| health\_info | Additional information about the the Vertex AI Workbench instance's health. |
| health\_state | The health state of the Vertex AI Workbench instance. |
| id | The Vertex AI Workbench instance ID. |
| proxy\_uri | The proxy endpoint that is used to access the Jupyter notebook. |
| state | The state of the Vertex AI Workbench instance. |
| upgrade\_history | The upgrade history of the Vertex AI Workbench instance. |
| work\_bench | Workbenchs created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v1.3+
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v4.79+

### Enable API's
In order to operate with the Service Account you must activate the following API on the project where the Service Account was created:

- compute.googleapis.com
- iap.googleapis.com
- aiplatform.googleapis.com
- notebooks.googleapis.com
- cloudkms.googleapis.com

### Service Account

A service account with the following roles must be used to provision the resources of this module:

- Notebooks Admin: `roles/notebooks.admin`
- Cloud KMS CryptoKey Encrypter/Decrypter : `roles/cloudkms.cryptoKeyEncrypterDecrypter`
- Cloud KMS Admin: `roles/cloudkms.admin`
- Compute Network Admin: `roles/compute.networkAdmin`
- Project IAM Admin: `roles/resourcemanager.projectIamAdmin`
- Service Account Admin: `roles/iam.serviceAccountAdmin`
- Service Account User: `roles/iam.serviceAccountUser`
