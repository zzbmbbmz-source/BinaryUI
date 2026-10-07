-- BinaryUI Loader
-- Loads the modular BinaryUI source tree through a virtual ModuleScript environment.
-- This is intended for environments that provide loadstring and game:HttpGet.

local CONFIG = {
    Owner = "zzbmbbmz-source",
    Repo = "BinaryUI",
    Branch = "main",
    Version = "v0.2-loader",
    Entry = "src/BinaryUI.lua",
    MaxRetries = 2,
    PreloadAll = true,
    Debug = false,
}

local REQUIRED = {
    "src/BinaryUI.lua",
    "src/Components/Button.lua",
    "src/Components/Checkbox.lua",
    "src/Components/Divider.lua",
    "src/Components/Dropdown.lua",
    "src/Components/Keybind.lua",
    "src/Components/Label.lua",
    "src/Components/Notification.lua",
    "src/Components/Paragraph.lua",
    "src/Components/Section.lua",
    "src/Components/Slider.lua",
    "src/Components/Tab.lua",
    "src/Components/Textbox.lua",
    "src/Components/Toggle.lua",
    "src/Components/Window.lua",
    "src/Core/Init.lua",
    "src/Core/Lifecycle.lua",
    "src/Core/Registry.lua",
    "src/Core/Signals.lua",
    "src/Core/State.lua",
    "src/Services/Animation.lua",
    "src/Services/Cleanup.lua",
    "src/Services/Focus.lua",
    "src/Services/Input.lua",
    "src/Services/Layout.lua",
    "src/Services/Storage.lua",
    "src/Services/Theme.lua",
    "src/Services/Tween.lua",
    "src/Safety/ConnectionGuard.lua",
    "src/Safety/ErrorHandler.lua",
    "src/Safety/InstanceGuard.lua",
    "src/Safety/RateLimiter.lua",
    "src/Safety/Recovery.lua",
    "src/Safety/SafeCall.lua",
    "src/Safety/StateGuard.lua",
    "src/Utils/Defaults.lua",
    "src/Utils/Helpers.lua",
    "src/Utils/Math.lua",
    "src/Utils/Validation.lua",
    "src/Config/DefaultSettings.lua",
    "src/Config/DefaultTheme.lua",
}

local Loader = {
    Version = CONFIG.Version,
    Diagnostics = {
        Version = CONFIG.Version,
        Loaded = {},
        Failed = {},
        Sources = {},
        Started = os.clock(),
        Completed = false,
    },
}

local function push(list, value)
    list[#list + 1] = value
end

local function rawUrl(path)
    return ("https://raw.githubusercontent.com/%s/%s/%s/%s"):format(CONFIG.Owner, CONFIG.Repo, CONFIG.Branch, path)
end

local function cdnUrl(path)
    return ("https://cdn.jsdelivr.net/gh/%s/%s@%s/%s"):format(CONFIG.Owner, CONFIG.Repo, CONFIG.Branch, path)
end

local function httpGet(url)
    if type(game) ~= "userdata" and type(game) ~= "table" then
        error("BinaryUI Loader: game is unavailable")
    end

    local ok, result = pcall(function()
        return game:HttpGet(url, true)
    end)
    if ok and type(result) == "string" and #result > 0 then
        return result
    end

    ok, result = pcall(function()
        return game:HttpGet(url)
    end)
    if ok and type(result) == "string" and #result > 0 then
        return result
    end

    error(tostring(result or "HttpGet failed"))
end

local function fetch(path)
    local urls = {rawUrl(path), cdnUrl(path)}
    local lastError = "unknown error"

    for _, url in ipairs(urls) do
        for attempt = 1, CONFIG.MaxRetries + 1 do
            local ok, result = pcall(httpGet, url)
            if ok and type(result) == "string" and #result > 0 then
                Loader.Diagnostics.Sources[path] = url
                return result
            end
            lastError = tostring(result)
            task.wait(math.min(attempt * 0.15, 0.5))
        end
    end

    error(("Failed to fetch %s: %s"):format(path, lastError))
end

local Node = {}
Node.__index = function(self, key)
    if key == "Parent" or key == "Name" or key == "Children" or key == "Path" or key == "IsModule" then
        return rawget(self, key)
    end
    local children = rawget(self, "Children")
    if children and children[key] then
        return children[key]
    end

    if rawget(self, "IsModule") then
        local parent = rawget(self, "Parent")
        local siblings = parent and rawget(parent, "Children")
        if siblings and siblings[key] then
            return siblings[key]
        end
    end

    return nil
end

local root = setmetatable({
    Name = "BinaryUI",
    Path = "",
    Parent = nil,
    Children = {},
    IsModule = false,
}, Node)

local nodes = {}

local function ensureNode(path, isModule)
    local current = root
    local parts = string.split(path, "/")
    for i, part in ipairs(parts) do
        local child = current.Children[part]
        if not child then
            local childPath = current.Path == "" and part or current.Path .. "/" .. part
            child = setmetatable({
                Name = part,
                Path = childPath,
                Parent = current,
                Children = {},
                IsModule = false,
            }, Node)
            current.Children[part] = child
        end
        if i == #parts then
            child.IsModule = isModule == true
            nodes[path] = child
        end
        current = child
    end
    return current
end

for _, path in ipairs(REQUIRED) do
    ensureNode(path, true)
end

local sources = {}
local compiled = {}
local cache = {}
local loading = {}

local function compile(path)
    if compiled[path] then
        return compiled[path]
    end

    local source = sources[path]
    if not source then
        source = fetch(path)
        sources[path] = source
    end

    local chunk, compileError = loadstring(source, "@BinaryUI/" .. path)
    if not chunk then
        error(("Compile error in %s: %s"):format(path, tostring(compileError)))
    end

    compiled[path] = chunk
    return chunk
end

local function moduleRequire(target)
    if type(target) ~= "table" or not target.IsModule then
        error("BinaryUI Loader: require() received an invalid module node")
    end

    local path = target.Path
    if cache[path] ~= nil then
        return cache[path]
    end

    if loading[path] then
        error("BinaryUI Loader: circular dependency detected at " .. path)
    end

    loading[path] = true

    local chunk = compile(path)
    local env = setmetatable({
        script = target,
        require = moduleRequire,
    }, {
        __index = getfenv and getfenv() or _G,
    })

    if not setfenv then
        loading[path] = nil
        error("BinaryUI Loader: setfenv is unavailable in this runtime")
    end

    setfenv(chunk, env)

    local ok, result = xpcall(chunk, function(err)
        return debug.traceback(tostring(err), 2)
    end)

    loading[path] = nil

    if not ok then
        Loader.Diagnostics.Failed[path] = result
        error(("Module error in %s: %s"):format(path, result))
    end

    cache[path] = result
    Loader.Diagnostics.Loaded[path] = true
    return result
end

local function validateAll()
    for _, path in ipairs(REQUIRED) do
        local ok, err = pcall(function()
            moduleRequire(nodes[path])
        end)
        if not ok then
            Loader.Diagnostics.Failed[path] = tostring(err)
        end
    end

    return next(Loader.Diagnostics.Failed) == nil
end

Loader.Validate = validateAll
Loader.GetDiagnostics = function()
    return Loader.Diagnostics
end

local ok, result = xpcall(function()
    if CONFIG.PreloadAll then
        if not validateAll() then
            error("BinaryUI Loader: one or more modules failed validation")
        end
    end

    local api = moduleRequire(nodes[CONFIG.Entry])
    if type(api) ~= "table" then
        error("BinaryUI Loader: entry module did not return a table")
    end

    api.Loader = Loader
    api.GetLoaderDiagnostics = function()
        return Loader.Diagnostics
    end

    Loader.Diagnostics.Completed = true
    Loader.Diagnostics.Duration = os.clock() - Loader.Diagnostics.Started

    if CONFIG.Debug then
        print(("[BinaryUI] loaded %d modules in %.3fs"):format(
            #REQUIRED,
            Loader.Diagnostics.Duration
        ))
    end

    return api
end, function(err)
    return debug.traceback(tostring(err), 2)
end)

if not ok then
    Loader.Diagnostics.Duration = os.clock() - Loader.Diagnostics.Started
    error(result)
end

return result
