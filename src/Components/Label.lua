local Label={}
Label.__index=Label
function Label.new(section,o)
    local self=setmetatable({},Label); local theme=section.Tab.Window._theme:Get(); local c=theme.Colors
    self.Instance=Instance.new("TextLabel"); self.Instance.Size=UDim2.new(1,0,0,24); self.Instance.BackgroundTransparency=1; self.Instance.Font=theme.Fonts.Main; self.Instance.TextSize=12; self.Instance.TextColor3=c.Muted; self.Instance.TextXAlignment=Enum.TextXAlignment.Left; self.Instance.Text=type(o.Text)=="string" and o.Text or ""; self.Instance.Parent=section.Frame
    return self
end
function Label:Set(v) if type(v)=="string" then self.Instance.Text=v end end
function Label:Destroy() if self.Instance then self.Instance:Destroy() end end
return Label
