local State = require(script.State)
local Registry = require(script.Registry)
local Lifecycle = require(script.Lifecycle)
local Signals = require(script.Signals)

local Core = {}
Core.__index = Core

function Core.new(options)
    local self = setmetatable({}, Core)
    self.State = State.new(options.State)
    self.Registry = Registry.new()
    self.Lifecycle = Lifecycle.new()
    self.Signals = Signals
    return self
end

function Core:Destroy()
    self.Registry:Clear()
    self.State:Destroy()
    self.Lifecycle:Destroy()
end

return Core
