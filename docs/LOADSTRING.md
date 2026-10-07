# Loadstring Loader

## Flow
~~~text
loadstring
   ↓
Loader.lua
   ↓
fetch + retry + fallback
   ↓
virtual ModuleScript tree
   ↓
dependency-aware require
   ↓
module validation/preload
   ↓
src/BinaryUI.lua
   ↓
BinaryUI API
~~~

## Example
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
    Name = "Loader Test",
    Callback = function()
        print("BinaryUI OK")
    end,
})
~~~

## Recovery model
The loader tries GitHub Raw first and jsDelivr second. Each source gets retries. A module is only considered loaded after its source compiles and its dependency chain executes successfully.

The loader also detects circular module dependencies and records failed module paths in diagnostics.

## Diagnostics
~~~lua
local d = BinaryUI:GetLoaderDiagnostics()

print("Version:", d.Version)
print("Completed:", d.Completed)
print("Duration:", d.Duration)

for path in pairs(d.Loaded) do
    print("OK:", path)
end

for path, message in pairs(d.Failed) do
    warn("FAILED:", path, message)
end
~~~

## Important
The loader requires a runtime that exposes `loadstring` and `game:HttpGet`. The framework's normal ModuleScript architecture does not require those APIs.