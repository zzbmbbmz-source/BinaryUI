local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Dropdown={}
Dropdown.__index=Dropdown
function Dropdown.new(section,o)
    local self=setmetatable({},Dropdown)
    self._errors=section.Tab.Window._errors
    self._name=type(o.Name)=="string" and o.Name or "Dropdown"
    self.Options=type(o.Options)=="table" and table.clone(o.Options) or {}
    self._value=table.find(self.Options,o.Default) and o.Default or self.Options[1]
    self._callback=o.Callback
    self._destroyed=false
    local c=section.Tab.Window._theme:Get().Colors
    self.Instance=Instance.new("TextButton"); self.Instance.Size=UDim2.new(1,0,0,36); self.Instance.BackgroundColor3=c.Surface2; self.Instance.TextColor3=c.Text; self.Instance.Font=section.Tab.Window._theme:Get().Fonts.Main; self.Instance.TextSize=12; self.Instance.Parent=section.Frame
    self:_render()
    self.Instance.Activated:Connect(function() if self._destroyed or #self.Options==0 then return end local i=table.find(self.Options,self._value) or 0; self:Set(self.Options[i+1] or self.Options[1]) end)
    return self
end
function Dropdown:_render() if self.Instance then self.Instance.Text=self._name..": "..tostring(self._value or "Select") end end
function Dropdown:Set(value,silent) if self._destroyed or not table.find(self.Options,value) or self._value==value then return false end self._value=value; self:_render(); if not silent then SafeCall.run(self._errors,self._callback,value) end return true end
function Dropdown:SetOptions(options) if self._destroyed or type(options)~="table" then return false end self.Options=table.clone(options); if not table.find(self.Options,self._value) then self._value=self.Options[1] end; self:_render(); return true end
function Dropdown:Get() return self._value end
function Dropdown:Destroy() if self._destroyed then return end self._destroyed=true; if self.Instance then self.Instance:Destroy() end end
return Dropdown
