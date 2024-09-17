/*
 *
 * Author :  Randy Guo (randyzwguo@qq.com) 
 *
 */


output "project_id" {
  value       = var.project_id
  description = "The project ID"
}

output "workbench_name" {
  value       = module.simple_vertex_ai_workbench.workbench_name
  description = "The name of the Vertex AI Workbench instance"
}

output "workbench" {
  value       = module.simple_vertex_ai_workbench
  description = "The Vertex AI Workbench instance"
}

output "service_account" {
  value       = google_service_account.workbench_sa.email
  description = "The service account for Vertex AI Workbench instance"
}

output "network" {
  value       = module.test-vpc-module.network_self_link
  description = "The network for Vertex AI Workbench instance"
}

output "subnet" {
  value       = module.test-vpc-module.subnets_self_links[0]
  description = "The subnet for Vertex AI Workbench instance"
}
