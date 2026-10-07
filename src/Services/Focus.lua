local UIS=game:GetService("UserInputService")
local Focus={}
function Focus.Clear() pcall(function() UIS.MouseBehavior=Enum.MouseBehavior.Default end) end
function Focus.IsTextFocused() return UIS:GetFocusedTextBox()~=nil end
return Focus
