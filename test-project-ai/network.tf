/*
 *
 * Author :  Randy Guo (randyzwguo@qq.com) 
 *
 */

resource "random_id" "suffix" {
  byte_length = 4
}

module "test-vpc-module" {
  source       = "terraform-google-modules/network/google"
  version      = "~> 9.0"
  project_id   = var.project_id
  network_name = "test-workbench"
  mtu          = 1460
  subnets = [
    {
      subnet_name           = "test-subnet-01"
      subnet_ip             = "10.10.10.0/24"
      subnet_region         = var.workbench_region
      subnet_private_access = true
    },
  ]
}
