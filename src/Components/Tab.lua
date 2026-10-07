local Cleanup=require(script.Parent.Parent.Services.Cleanup)
local Tab={}
Tab.__index=Tab
function Tab.new(window,o)
    local self=setmetatable({},Tab); self.Window=window; self.Name=type(o.Name)=="string" and o.Name or "Tab"; self._cleanup=Cleanup.new()
    self.Frame=Instance.new("Frame"); self.Frame.Name=self.Name:gsub("%W","_"); self.Frame.Size=UDim2.new(1,0,0,0); self.Frame.AutomaticSize=Enum.AutomaticSize.Y; self.Frame.BackgroundTransparency=1; self.Frame.Parent=window.Content; self._cleanup:Add(self.Frame)
    local layout=Instance.new("UIListLayout"); layout.Padding=UDim.new(0,8); layout.SortOrder=Enum.SortOrder.LayoutOrder; layout.Parent=self.Frame; self._cleanup:Add(layout)
    return self
end
function Tab:AddSection(o) return require(script.Parent.Section).new(self,o or {}) end
function Tab:Destroy() self._cleanup:Destroy() end
return Tab
