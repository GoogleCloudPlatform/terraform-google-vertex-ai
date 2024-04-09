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

variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "instance_owners" {
  description = "The owner of this instance after creation. Format: alias@example.com Currently supports one owner only. If not specified, all of the service account users of your VM instance''s service account can use the instance"
  type        = list(string)
  default     = ["imrannayer@google.com"]
}

variable "bucket_timestamp" {
  description = "Timestamp of when access to BYOD will expire (ISO 8601 format - ex. 2020-01-01T00:00:00Z)"
  type        = string
  default     = null
}

variable "byod_access_group" {
  description = "The AD group able to access the bucket"
  type        = string
  default     = null
}
