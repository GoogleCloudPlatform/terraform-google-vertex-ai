/*
 *
 * Author :  Randy Guo (randyzwguo@qq.com) 
 *
 */

resource "google_service_account" "workbench_sa" {
  account_id   = "vertex-ai-workbench-sa"
  display_name = "Vertex AI Workbench Service Account"
  project      = var.project_id
}

module "test-project-ai_workbench" {
  source  = "GoogleCloudPlatform/vertex-ai/google//modules/workbench"
  version = "~> 0.1"

  name       = "test-project-ai-workbench"
  location   = var.workbench_region
  project_id = var.project_id

  machine_type = "e2-standard-2"

  labels = {
    env  = "test"
    type = "workbench"
  }

  service_accounts = [
    {
      email = google_service_account.workbench_sa.email
    },
  ]

  data_disks = [
    {
      disk_size_gb = 330
      disk_type    = "PD_BALANCED"
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
