local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Button={}
Button.__index=Button
function Button.new(section,o)
    local self=setmetatable({},Button); self._errors=section.Tab.Window._errors; self._destroyed=false; self._callback=o.Callback
    local theme=section.Tab.Window._theme:Get(); local c=theme.Colors
    self.Instance=Instance.new("TextButton"); self.Instance.Size=UDim2.new(1,0,0,36); self.Instance.BackgroundColor3=c.Surface2; self.Instance.TextColor3=c.Text; self.Instance.Font=theme.Fonts.Main; self.Instance.TextSize=13; self.Instance.Text=type(o.Name)=="string" and o.Name or "Button"; self.Instance.Parent=section.Frame
    local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,6); corner.Parent=self.Instance
    self._connection=self.Instance.Activated:Connect(function() if not self._destroyed then SafeCall.run(self._errors,self._callback) end end)
    return self
end
function Button:Destroy() if self._destroyed then return end self._destroyed=true; pcall(function() self._connection:Disconnect() end); if self.Instance then self.Instance:Destroy() end end
return Button
