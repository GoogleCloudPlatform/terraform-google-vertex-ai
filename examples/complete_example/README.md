# Vertex AI Workbench Instance example
deploy vertex AI Workbench Instance

## Usage

To run this example you need to set parameters (see [example tfvar](./terraform.tfvars.example) file) and execute:


```bash
terraform init
terraform plan
terraform apply
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accelerator\_configs | GPU accelerator configuration. Possible values for type: NVIDIA\_TESLA\_P100, NVIDIA\_TESLA\_V100, NVIDIA\_TESLA\_P4, NVIDIA\_TESLA\_T4, NVIDIA\_TESLA\_A100, NVIDIA\_A100\_80GB, NVIDIA\_L4, NVIDIA\_TESLA\_T4\_VWS, NVIDIA\_TESLA\_P100\_VWS, NVIDIA\_TESLA\_P4\_VWS | <pre>list(object({<br>    type       = optional(string)<br>    core_count = optional(number)<br>  }))</pre> | `null` | no |
| boot\_disk\_size\_gb | The size of the boot disk in GB attached to this instance, up to a maximum of 64000 GB (64 TB). If not specified, this defaults to the recommended value of 150GB | `number` | `150` | no |
| boot\_disk\_type | Indicates the type of the boot disk. Possible values are: PD\_STANDARD, PD\_SSD, PD\_BALANCED, PD\_EXTREME | `string` | `"PD_BALANCED"` | no |
| bucket\_location | Common region that can be used for multiple Vertex AI Workbench Instances | `string` | n/a | yes |
| bucket\_prefix | The name of the bucket | `string` | n/a | yes |
| bucket\_storage\_class | The storage class of the bucket | `string` | `null` | no |
| bucket\_timestamp | Timestamp of when access to BYOD will expire (ISO 8601 format - ex. 2020-01-01T00:00:00Z) | `string` | `null` | no |
| bucket\_versioning | Specifies if versioning should be enabled for the bucket | `bool` | `true` | no |
| byod\_access\_group | The AD group able to access the bucket | `string` | `null` | no |
| data\_disks | n/a | <pre>list(object({<br>    disk_size_gb = optional(number, 100)<br>    disk_type    = optional(string, "PD_BALANCED")<br>  }))</pre> | `null` | no |
| desired\_state | Desired state of the Workbench Instance. Set this field to ACTIVE to start the Instance, and STOPPED to stop the Instance | `string` | `null` | no |
| disable\_proxy\_access | If true, the workbench instance will not register with the proxy | `bool` | `true` | no |
| disable\_public\_ip | If true, no external IP will be assigned to this VM instance | `bool` | `true` | no |
| disk\_encryption | Disk encryption method used on the boot and data disks, defaults to GMEK. Possible values are: GMEK, CMEK | `string` | `"CMEK"` | no |
| enable\_ip\_forwarding | Flag to enable ip forwarding or not, default false/off | `bool` | `false` | no |
| instance\_id | User-defined unique ID of this instance | `string` | `null` | no |
| instance\_owners | The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance | `list(string)` | `null` | no |
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
| byod\_bucket\_name | BYOD bucket name |
| creator | Email address of entity that sent original CreateInstance request. |
| health\_info | Additional information about the the Vertex AI Workbench instance's health. |
| health\_state | The health state of the Vertex AI Workbench instance. |
| id | The Vertex AI Workbench instance ID. |
| proxy\_uri | The proxy endpoint that is used to access the Jupyter notebook. |
| state | The state of the Vertex AI Workbench instance. |
| upgrade\_history | The upgrade history of the Vertex AI Workbench instance. |
| work\_bench | Workbenchs created |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
