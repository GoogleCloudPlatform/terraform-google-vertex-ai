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
  description = "The unique identifier for the created ReasoningEngine resource."
  value       = module.reasoning_engine.reasoning_engine_id
}

output "reasoning_engine_name" {
  description = "The generated name of the created ReasoningEngine."
  value       = module.reasoning_engine.reasoning_engine_name
}

output "reasoning_engine_create_time" {
  description = "The timestamp of when the created ReasoningEngine was created."
  value       = module.reasoning_engine.reasoning_engine_create_time
}

output "reasoning_engine_update_time" {
  description = "The timestamp of when the created ReasoningEngine was last updated."
  value       = module.reasoning_engine.reasoning_engine_update_time
}

output "project" {
  description = "The project ID where the ReasoningEngine was created."
  value       = var.project
}
