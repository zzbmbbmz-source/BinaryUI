local InstanceGuard = {}

function InstanceGuard.Destroy(instance)
    if typeof(instance) ~= "Instance" then return false end
    if instance.Parent == nil then return true end
    return pcall(function() instance:Destroy() end)
end

function InstanceGuard.IsAlive(instance)
    return typeof(instance) == "Instance" and instance.Parent ~= nil
end

return InstanceGuard
