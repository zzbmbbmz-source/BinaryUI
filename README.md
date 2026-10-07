# BinaryUI

A defensive, modular Roblox Luau UI framework built around isolation, safe callbacks, deterministic cleanup, validation, lifecycle management, and mobile-friendly controls.

## Design

- Modular components with no shared mutable globals
- Safe callback execution so user callbacks cannot break the UI loop
- Idempotent destruction and connection cleanup
- Centralized theme and tween services
- State and UI are separated
- Registry prevents duplicate component identifiers
- Defensive validation and recovery hooks
- Mouse, touch, and gamepad-friendly input paths
- No executor-specific APIs

## Layout

```
src/
  BinaryUI.lua
  Core/
  Components/
  Services/
  Safety/
  Utils/
  Config/
examples/
tests/
docs/
```

## Basic usage

Place the `src` tree into Roblox as ModuleScripts/ModuleScript folders and require `src/BinaryUI`.

```lua
local BinaryUI = require(path.To.BinaryUI)

local window = BinaryUI:CreateWindow({
    Title = "BinaryUI",
    Subtitle = "Obsidian Neon",
})

local tab = window:AddTab({Name = "Main"})
local section = tab:AddSection({Name = "Controls"})

section:AddButton({
    Name = "Hello",
    Callback = function()
        print("Hello from BinaryUI")
    end,
})

section:AddToggle({
    Name = "Enabled",
    Default = true,
    Callback = function(value)
        print("Enabled:", value)
    end,
})
```

See `examples/Showcase.lua` and `docs/COMPONENTS.md`.
