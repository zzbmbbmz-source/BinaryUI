local UserInputService = game:GetService("UserInputService")
local Input = {}

function Input.IsTouch()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

function Input.Bind(guiObject, callback)
    if typeof(guiObject) ~= "Instance" or type(callback) ~= "function" then
        return {Disconnect=function() end}
    end
    return guiObject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            pcall(callback, input)
        end
    end)
end

return Input
