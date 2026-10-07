local UIS=game:GetService("UserInputService")
local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local ConnectionGuard=require(script.Parent.Parent.Safety.ConnectionGuard)
local Slider={}
Slider.__index=Slider
function Slider.new(section,o)
    local self=setmetatable({},Slider); self._errors=section.Tab.Window._errors; self.Min=type(o.Min)=="number" and o.Min or 0; self.Max=type(o.Max)=="number" and o.Max or 100; if self.Max<=self.Min then self.Max=self.Min+1 end
    self._value=math.clamp(type(o.Default)=="number" and o.Default or self.Min,self.Min,self.Max); self._callback=o.Callback; self._connections=ConnectionGuard.new(); self._destroyed=false
    local theme=section.Tab.Window._theme:Get(); local c=theme.Colors
    self.Frame=Instance.new("Frame"); self.Frame.Size=UDim2.new(1,0,0,52); self.Frame.BackgroundTransparency=1; self.Frame.Parent=section.Frame
    self.Label=Instance.new("TextLabel"); self.Label.Size=UDim2.new(1,0,0,20); self.Label.BackgroundTransparency=1; self.Label.Font=theme.Fonts.Main; self.Label.TextSize=12; self.Label.TextColor3=c.Text; self.Label.TextXAlignment=Enum.TextXAlignment.Left; self.Label.Parent=self.Frame
    self.Name=type(o.Name)=="string" and o.Name or "Slider"
    self.Bar=Instance.new("Frame"); self.Bar.Position=UDim2.fromOffset(0,28); self.Bar.Size=UDim2.new(1,0,0,6); self.Bar.BackgroundColor3=c.Surface2; self.Bar.BorderSizePixel=0; self.Bar.Active=true; self.Bar.Parent=self.Frame
    self.Fill=Instance.new("Frame"); self.Fill.BackgroundColor3=c.Accent; self.Fill.BorderSizePixel=0; self.Fill.Parent=self.Bar
    local dragging=false
    local function update(x) if self._destroyed then return end local a=math.clamp((x-self.Bar.AbsolutePosition.X)/math.max(self.Bar.AbsoluteSize.X,1),0,1); self:Set(self.Min+(self.Max-self.Min)*a) end
    self._connections:Add(self.Bar.InputBegan:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=true; update(input.Position.X) end end))
    self._connections:Add(UIS.InputChanged:Connect(function(input) if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then update(input.Position.X) end end))
    self._connections:Add(UIS.InputEnded:Connect(function(input) if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end end))
    self:_render(); return self
end
function Slider:_render() local a=(self._value-self.Min)/(self.Max-self.Min); self.Fill.Size=UDim2.fromScale(a,1); self.Label.Text=self.Name..": "..string.format("%.2f",self._value) end
function Slider:Get() return self._value end
function Slider:Set(v,silent) if self._destroyed or type(v)~="number" then return false end local n=math.clamp(v,self.Min,self.Max); if self._value==n then return false end self._value=n; self:_render(); if not silent then SafeCall.run(self._errors,self._callback,n) end return true end
function Slider:Destroy() if self._destroyed then return end self._destroyed=true; self._connections:Cleanup(); if self.Frame then self.Frame:Destroy() end end
return Slider
