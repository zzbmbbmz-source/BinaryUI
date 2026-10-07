local Divider={}
Divider.__index=Divider
function Divider.new(section)
    local self=setmetatable({},Divider); local c=section.Tab.Window._theme:Get().Colors
    self.Instance=Instance.new("Frame"); self.Instance.Size=UDim2.new(1,0,0,1); self.Instance.BackgroundColor3=c.Muted; self.Instance.BackgroundTransparency=.75; self.Instance.BorderSizePixel=0; self.Instance.Parent=section.Frame
    return self
end
function Divider:Destroy() if self.Instance then self.Instance:Destroy() end end
return Divider
