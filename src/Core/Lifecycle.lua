local Lifecycle = {}
Lifecycle.__index = Lifecycle

function Lifecycle.new()
    return setmetatable({phase="New", _destroyed=false}, Lifecycle)
end

function Lifecycle:Set(phase)
    if self._destroyed then return false end
    self.phase = phase
    return true
end

function Lifecycle:IsDestroyed()
    return self._destroyed
end

function Lifecycle:Destroy()
    self._destroyed = true
    self.phase = "Destroyed"
end

return Lifecycle
