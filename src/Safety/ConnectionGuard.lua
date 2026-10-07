local ConnectionGuard = {}
ConnectionGuard.__index = ConnectionGuard

function ConnectionGuard.new()
    return setmetatable({_connections={}, _destroyed=false}, ConnectionGuard)
end

function ConnectionGuard:Add(connection)
    if self._destroyed or not connection then return connection end
    table.insert(self._connections, connection)
    return connection
end

function ConnectionGuard:Cleanup()
    if self._destroyed then return end
    self._destroyed = true
    for _, connection in ipairs(self._connections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(self._connections)
end

return ConnectionGuard
