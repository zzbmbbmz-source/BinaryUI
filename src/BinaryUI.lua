local Core = require(script.Core.Init)
local Window = require(script.Components.Window)
local Theme = require(script.Services.Theme)
local ErrorHandler = require(script.Safety.ErrorHandler)
local Defaults = require(script.Utils.Defaults)

local BinaryUI = {}
BinaryUI.__index = BinaryUI

function BinaryUI.new(options)
    options = type(options) == "table" and options or {}
    local self = setmetatable({}, BinaryUI)
    self._core = Core.new(options)
    self._theme = Theme.new(options.Theme or Defaults.Theme)
    self._errorHandler = ErrorHandler.new(options.Debug == true)
    self._windows = {}
    return self
end

function BinaryUI:CreateWindow(options)
    local window = Window.new(self._core, self._theme, self._errorHandler, options or {})
    self._windows[window:GetId()] = window
    window.Destroyed:Connect(function()
        self._windows[window:GetId()] = nil
    end)
    return window
end

function BinaryUI:SetTheme(theme)
    self._theme:Set(theme)
    for _, window in pairs(self._windows) do
        window:RefreshTheme()
    end
end

function BinaryUI:GetTheme()
    return self._theme:Get()
end

function BinaryUI:Destroy()
    for _, window in pairs(self._windows) do
        pcall(function() window:Destroy() end)
    end
    table.clear(self._windows)
    self._core:Destroy()
end

return BinaryUI.new()
