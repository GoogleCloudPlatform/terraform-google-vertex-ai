import os
from google.adk.agents import LlmAgent
from google.genai import types
from vertexai.preview.reasoning_engines import AdkApp




simple_llm_agent = LlmAgent(
    name="simple_assistant",
    model="gemini-2.5-pro", # Use a standard model name
    description="A simple interactive agent for general conversation.",
    instruction=(
        "You are a helpful, friendly, and knowledgeable AI assistant. "
        "Keep your answers clear, concise, and well-structured."
    )
)

root_agent = AdkApp(
    agent=simple_llm_agent,
    enable_tracing=True,
)
