local UIS=game:GetService("UserInputService")
local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Keybind={}
Keybind.__index=Keybind
function Keybind.new(section,o)
    local self=setmetatable({},Keybind); self._errors=section.Tab.Window._errors; self._callback=o.Callback; self._key=o.Key or Enum.KeyCode.RightShift; self._destroyed=false; self._listening=false
    local theme=section.Tab.Window._theme:Get(); local c=theme.Colors; self._name=type(o.Name)=="string" and o.Name or "Keybind"
    self.Instance=Instance.new("TextButton"); self.Instance.Size=UDim2.new(1,0,0,36); self.Instance.BackgroundColor3=c.Surface2; self.Instance.TextColor3=c.Text; self.Instance.Font=theme.Fonts.Main; self.Instance.TextSize=12; self.Instance.Parent=section.Frame
    self:_render()
    self._connection=UIS.InputBegan:Connect(function(input,gp) if not gp and not self._destroyed then if self._listening and input.KeyCode~=Enum.KeyCode.Unknown then self._key=input.KeyCode; self._listening=false; self:_render() elseif input.KeyCode==self._key then SafeCall.run(self._errors,self._callback,self._key) end end end)
    self.Instance.Activated:Connect(function() self._listening=true; self.Instance.Text=self._name..": Press a key..." end)
    return self
end
function Keybind:_render() self.Instance.Text=self._name..": "..self._key.Name end
function Keybind:Set(key) if typeof(key)=="EnumItem" and key.EnumType==Enum.KeyCode then self._key=key; self:_render(); return true end return false end
function Keybind:Get() return self._key end
function Keybind:Destroy() if self._destroyed then return end self._destroyed=true; pcall(function() self._connection:Disconnect() end); if self.Instance then self.Instance:Destroy() end end
return Keybind
