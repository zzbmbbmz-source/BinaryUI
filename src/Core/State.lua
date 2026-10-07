local State = {}
State.__index = State

function State.new(initial)
    local self = setmetatable({}, State)
    self._values = type(initial) == "table" and table.clone(initial) or {}
    self._listeners = {}
    self._destroyed = false
    return self
end

function State:Get(key, fallback)
    if self._destroyed then return fallback end
    local value = self._values[key]
    return value == nil and fallback or value
end

function State:Set(key, value)
    if self._destroyed then return false end
    local old = self._values[key]
    if old == value then return false end
    self._values[key] = value
    local listeners = self._listeners[key]
    if listeners then
        for _, callback in pairs(table.clone(listeners)) do
            pcall(callback, value, old)
        end
    end
    return true
end

function State:Observe(key, callback)
    if self._destroyed or type(callback) ~= "function" then
        return function() end
    end
    self._listeners[key] = self._listeners[key] or {}
    local token = {}
    self._listeners[key][token] = callback
    return function()
        local list = self._listeners[key]
        if list then list[token] = nil end
    end
end

function State:Destroy()
    self._destroyed = true
    table.clear(self._values)
    table.clear(self._listeners)
end

return State
