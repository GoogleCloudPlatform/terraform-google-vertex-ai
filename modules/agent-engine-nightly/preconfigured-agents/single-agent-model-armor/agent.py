# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import os
from google.adk.agents import LlmAgent
from google.genai import types
from vertexai.preview.reasoning_engines import AdkApp

template_id = os.environ.get("model_armor_template_1_MODEL_ARMOR_TEMPLATE_ID")

simple_llm_agent = LlmAgent(
    name="simple_assistant",
    model="gemini-2.5-pro",
    description="A simple interactive agent for general conversation.",
    instruction=(
        "You are a helpful, friendly, and knowledgeable AI assistant. "
        "Keep your answers clear, concise, and well-structured."
    ),
    generate_content_config=types.GenerateContentConfig(
        model_armor_config={
            "prompt_template_name": template_id,
            "response_template_name": template_id
        }
    )
)

root_agent = AdkApp(
    agent=simple_llm_agent,
    enable_tracing=True,
)
