# Runtime

Runtime-specific compatibility and capability checks live here.

- Keep runtime detection isolated from UI components.
- Check whether an optional function exists before calling it.
- Provide a safe fallback when a capability is unavailable.
- Do not assume executor-only APIs exist in standard Roblox Studio.