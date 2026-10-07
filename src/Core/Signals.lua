local Signal = {}
Signal.__index = Signal

function Signal.new()
    return setmetatable({
        _listeners = {},
        _destroyed = false,
    }, Signal)
end

function Signal:Connect(callback)
    if self._destroyed or type(callback) ~= "function" then
        return {Disconnect = function() end}
    end

    local token = {}
    self._listeners[token] = callback

    return {
        Disconnect = function()
            if self._listeners then
                self._listeners[token] = nil
            end
        end,
    }
end

function Signal:Fire(...)
    if self._destroyed then
        return
    end

    local args = table.pack(...)
    local listeners = table.clone(self._listeners)

    for _, callback in pairs(listeners) do
        pcall(callback, table.unpack(args, 1, args.n))
    end
end

function Signal:Destroy()
    if self._destroyed then
        return
    end

    self._destroyed = true
    table.clear(self._listeners)
end

return {new = Signal.new}
