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

module "reasoning_engine" {
  //source = "GoogleCloudPlatform/vertex-ai/google//modules/reasoning-engine"
  source = "../../modules/reasoning-engine"
  
  project           = var.project
  display_name      = "Vertex AI Reasoning Engine"
  region            = "us-central1"
  description       = "Reasoning Engine example"
}
