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

output "reasoning_engine_id" {
  description = "The unique identifier for the Reasoning Engine resource."
  value       = google_vertex_ai_reasoning_engine.main.id
}

output "reasoning_engine_name" {
  description = "The generated name of the Reasoning Engine."
  value       = google_vertex_ai_reasoning_engine.main.name
}

output "reasoning_engine" {
  description = "The full google_vertex_ai_reasoning_engine resource object."
  value       = google_vertex_ai_reasoning_engine.main
}

output "effective_identity" {
  description = "The service identity used for the Reasoning Engine deployment."
  value       = google_vertex_ai_reasoning_engine.main.spec[0].effective_identity
}

output "reasoning_engine_console_url" {
  description = "The URL to the Vertex AI Agent Engine console page."
  value       = "https://console.cloud.google.com/vertex-ai/agents/agent-engines/locations/${var.region}/agent-engines/${google_vertex_ai_reasoning_engine.main.name}/dashboard?project=${var.project_id}"
}

output "reasoning_engine_url" {
  description = "The full regional API URL for the Reasoning Engine interaction."
  value       = "https://${var.region}-aiplatform.googleapis.com/v1/projects/${var.project_id}/locations/${var.region}/reasoningEngines/${google_vertex_ai_reasoning_engine.main.name}"
}

output "discovery_filter" {
  description = "The pre-formatted filter string to discover this agent in the registry."
  value       = format("agentId:\"urn:agent:projects-%s:projects:%s:locations:%s:aiplatform:reasoningEngines:%s\"", data.google_project.project.number, data.google_project.project.number, var.region, google_vertex_ai_reasoning_engine.main.name)
}
