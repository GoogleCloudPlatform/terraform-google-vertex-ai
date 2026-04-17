import os
from google.adk.agents import LlmAgent
from google.genai import types
from vertexai.preview.reasoning_engines import AdkApp

# 1. Setup Environment
template_name = os.environ.get("model_armor_template_1_MODEL_ARMOR_TEMPLATE_ID")


# 2. Define the LLM Agent
simple_llm_agent = LlmAgent(
    name="simple_assistant",
    model="gemini-2.5-pro", # Use a standard model name
    description="A simple interactive agent for general conversation.",
    instruction=(
        "You are a helpful, friendly, and knowledgeable AI assistant. "
        "Keep your answers clear, concise, and well-structured."
    ),
    generate_content_config=types.GenerateContentConfig(
        model_armor_config={
            "prompt_template_name": template_name,
            "response_template_name": template_name
        }
    )
)

# 3. Wrap in AdkApp
root_agent = AdkApp(
    agent=simple_llm_agent,
    enable_tracing=True,
)
