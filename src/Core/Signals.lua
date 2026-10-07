local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({_listeners={}, _destroyed=false}, Signal)
end

function Signal:Connect(callback)
    if self._destroyed or type(callback) ~= "function" then
        return {Disconnect=function() end}
    end
    local token = {}
    self._listeners[token] = callback
    local connection = {}
    function connection:Disconnect()
        self._listeners = nil
        callback = nil
    end
    function connection:Disconnect()
        if self._listeners then self._listeners[token] = nil end
    end
    return connection
end

function Signal:Fire(...)
    if self._destroyed then return end
    local args = table.pack(...)
    for _, callback in pairs(table.clone(self._listeners)) do
        pcall(callback, table.unpack(args,1,args.n))
    end
end

function Signal:Destroy()
    self._destroyed = true
    table.clear(self._listeners)
end

return {new=Signal.new}
