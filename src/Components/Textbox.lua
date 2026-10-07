local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Textbox={}
Textbox.__index=Textbox
function Textbox.new(section,o)
    local self=setmetatable({},Textbox); self._errors=section.Tab.Window._errors; self._callback=o.Callback; self._destroyed=false
    local theme=section.Tab.Window._theme:Get(); local c=theme.Colors
    self.Instance=Instance.new("TextBox"); self.Instance.Size=UDim2.new(1,0,0,36); self.Instance.BackgroundColor3=c.Surface2; self.Instance.TextColor3=c.Text; self.Instance.PlaceholderColor3=c.Muted; self.Instance.Font=theme.Fonts.Main; self.Instance.TextSize=12; self.Instance.Text=type(o.Default)=="string" and o.Default or ""; self.Instance.PlaceholderText=type(o.Placeholder)=="string" and o.Placeholder or "Enter text..."; self.Instance.ClearTextOnFocus=false; self.Instance.Parent=section.Frame
    self._connection=self.Instance.FocusLost:Connect(function(enter) if not self._destroyed then SafeCall.run(self._errors,self._callback,self.Instance.Text,enter) end end)
    return self
end
function Textbox:Get() return self.Instance.Text end
function Textbox:Set(v) if type(v)=="string" and not self._destroyed then self.Instance.Text=v end end
function Textbox:Destroy() if self._destroyed then return end self._destroyed=true; pcall(function() self._connection:Disconnect() end); if self.Instance then self.Instance:Destroy() end end
return Textbox
