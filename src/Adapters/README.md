# Adapters

Optional integrations belong here so the core UI stays independent of any single runtime.

Adapters should expose a small, documented interface, validate inputs, and fail gracefully when an integration is missing. Keep ordinary Roblox Studio support separate from any environment-specific compatibility layer.