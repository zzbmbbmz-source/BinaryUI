local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Toggle={}
Toggle.__index=Toggle
function Toggle.new(section,o)
    local self=setmetatable({},Toggle); self._errors=section.Tab.Window._errors; self._value=type(o.Default)=="boolean" and o.Default or false; self._callback=o.Callback; self._destroyed=false
    local theme=section.Tab.Window._theme:Get(); local c=theme.Colors
    self.Instance=Instance.new("TextButton"); self.Instance.Size=UDim2.new(1,0,0,36); self.Instance.BackgroundColor3=c.Surface2; self.Instance.TextColor3=c.Text; self.Instance.Font=theme.Fonts.Main; self.Instance.TextSize=13; self.Instance.TextXAlignment=Enum.TextXAlignment.Left; self.Instance.Parent=section.Frame
    local pad=Instance.new("UIPadding"); pad.PaddingLeft=UDim.new(0,10); pad.Parent=self.Instance
    self._name=type(o.Name)=="string" and o.Name or "Toggle"; self:_render()
    self._connection=self.Instance.Activated:Connect(function() if not self._destroyed then self:Set(not self._value) end end)
    return self
end
function Toggle:_render() self.Instance.Text=self._name.."  ["..(self._value and "ON" or "OFF").."]" end
function Toggle:Get() return self._value end
function Toggle:Set(value,silent) if self._destroyed or type(value)~="boolean" or self._value==value then return false end self._value=value; self:_render(); if not silent then SafeCall.run(self._errors,self._callback,value) end return true end
function Toggle:Destroy() if self._destroyed then return end self._destroyed=true; pcall(function() self._connection:Disconnect() end); if self.Instance then self.Instance:Destroy() end end
return Toggle
