local Cleanup=require(script.Parent.Parent.Services.Cleanup)
local Section={}
Section.__index=Section
function Section.new(tab,o)
    local self=setmetatable({},Section)
    self.Tab=tab; self._cleanup=Cleanup.new()
    local theme=tab.Window._theme:Get(); local c=theme.Colors
    self.Frame=Instance.new("Frame"); self.Frame.Size=UDim2.new(1,0,0,0); self.Frame.AutomaticSize=Enum.AutomaticSize.Y; self.Frame.BackgroundColor3=c.Surface; self.Frame.BorderSizePixel=0; self.Frame.Parent=tab.Frame; self._cleanup:Add(self.Frame)
    local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,theme.Corner); corner.Parent=self.Frame
    local pad=Instance.new("UIPadding"); pad.PaddingTop=UDim.new(0,10); pad.PaddingBottom=UDim.new(0,10); pad.PaddingLeft=UDim.new(0,10); pad.PaddingRight=UDim.new(0,10); pad.Parent=self.Frame
    local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,6); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Parent=self.Frame
    local title=Instance.new("TextLabel"); title.Size=UDim2.new(1,0,0,22); title.BackgroundTransparency=1; title.Font=theme.Fonts.Main; title.TextSize=13; title.TextColor3=c.Text; title.TextXAlignment=Enum.TextXAlignment.Left; title.Text=type(o.Name)=="string" and o.Name or "Section"; title.Parent=self.Frame
    return self
end
function Section:AddButton(o) return require(script.Parent.Button).new(self,o or {}) end
function Section:AddToggle(o) return require(script.Parent.Toggle).new(self,o or {}) end
function Section:AddSlider(o) return require(script.Parent.Slider).new(self,o or {}) end
function Section:AddDropdown(o) return require(script.Parent.Dropdown).new(self,o or {}) end
function Section:AddTextbox(o) return require(script.Parent.Textbox).new(self,o or {}) end
function Section:AddLabel(o) return require(script.Parent.Label).new(self,o or {}) end
function Section:AddKeybind(o) return require(script.Parent.Keybind).new(self,o or {}) end
function Section:AddDivider() return require(script.Parent.Divider).new(self) end
function Section:Destroy() self._cleanup:Destroy() end
return Section
