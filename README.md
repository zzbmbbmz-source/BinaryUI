# BinaryUI

A defensive, modular Roblox Luau UI framework built around isolation, safe callbacks, deterministic cleanup, validation, lifecycle management, and mobile-friendly controls.

## Design
- Modular components with isolated responsibilities
- Safe callback execution so user callbacks cannot break the UI loop
- Idempotent destruction and connection cleanup
- Centralized theme and animation services
- State and UI are separated
- Registry prevents duplicate identifiers
- Defensive validation, recovery, and rate limiting
- Mouse and touch input paths
- Core framework does not depend on executor-only APIs
- Optional `Loader.lua` supports environments that expose `loadstring` and `game:HttpGet`

## Layout
~~~text
src/
  BinaryUI.lua
  Core/
  Components/
  Services/
  Safety/
  Utils/
  Config/
Loader.lua
examples/
docs/
~~~

## Standard ModuleScript usage
Place the `src` tree into Roblox as ModuleScripts/ModuleScript folders and require `src/BinaryUI`.

~~~lua
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
~~~

## Loadstring Loader
For runtimes that provide `loadstring` and `game:HttpGet`, the loader builds a virtual ModuleScript tree, loads the individual repository modules, validates them, and returns the normal BinaryUI API.

~~~lua
local BinaryUI = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/zzbmbbmz-source/BinaryUI/main/Loader.lua"
))()

local Window = BinaryUI:CreateWindow({
    Title = "BinaryUI",
    Subtitle = "Obsidian Neon",
})

local Tab = Window:AddTab({Name = "Main"})
local Section = Tab:AddSection({Name = "Controls"})

Section:AddButton({
    Name = "Test",
    Callback = function()
        print("BinaryUI loaded successfully")
    end,
})
~~~

### Loader recovery
1. Primary GitHub Raw source.
2. jsDelivr source fallback.
3. Per-module retry.
4. Compile checks.
5. Dependency-aware module loading.
6. Circular dependency detection.
7. Per-module failure diagnostics.
8. Full module preload before returning the API.

Diagnostics are available from `BinaryUI:GetLoaderDiagnostics()`.

See `examples/Showcase.lua`, `docs/COMPONENTS.md`, and `docs/LOADSTRING.md`.