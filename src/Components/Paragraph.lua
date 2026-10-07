local Label=require(script.Parent.Label)
local Paragraph={}
Paragraph.__index=Paragraph
function Paragraph.new(section,o)
    local self=setmetatable(Label.new(section,{Text=o.Text or ""}),Paragraph)
    self.Instance.Size=UDim2.new(1,0,0,42); self.Instance.TextWrapped=true; self.Instance.TextYAlignment=Enum.TextYAlignment.Top
    return self
end
return Paragraph
