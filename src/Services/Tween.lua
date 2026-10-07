local TweenService = game:GetService("TweenService")
local Tween = {}

function Tween.Play(instance, info, properties)
    if typeof(instance) ~= "Instance" or type(properties) ~= "table" then
        return nil
    end
    local ok, result = pcall(function()
        local tween = TweenService:Create(instance, info, properties)
        tween:Play()
        return tween
    end)
    return ok and result or nil
end

function Tween.Cancel(tween)
    if tween then pcall(function() tween:Cancel() end) end
end

return Tween
