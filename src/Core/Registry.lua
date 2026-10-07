local Registry = {}
Registry.__index = Registry

function Registry.new()
    return setmetatable({_items = {}, _destroyed = false}, Registry)
end

function Registry:Add(id, item)
    if self._destroyed or type(id) ~= "string" or id == "" or self._items[id] ~= nil then
        return false
    end
    self._items[id] = item
    return true
end

function Registry:Get(id)
    if self._destroyed then return nil end
    return self._items[id]
end

function Registry:Remove(id)
    if self._destroyed then return end
    self._items[id] = nil
end

function Registry:Clear()
    self._destroyed = true
    table.clear(self._items)
end

return Registry
