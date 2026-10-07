local Players=game:GetService("Players")
local Notification={}
Notification.__index=Notification
function Notification.new(theme,o)
    o=type(o)=="table" and o or {}
    local self=setmetatable({},Notification); self._destroyed=false
    local pg=Players.LocalPlayer and Players.LocalPlayer:FindFirstChildOfClass("PlayerGui"); if not pg then return self end
    local t=theme:Get(); local c=t.Colors
    self.Gui=Instance.new("ScreenGui"); self.Gui.Name="BinaryUI_Notifications"; self.Gui.ResetOnSpawn=false; self.Gui.DisplayOrder=100; self.Gui.Parent=pg
    local card=Instance.new("TextLabel"); card.AnchorPoint=Vector2.new(1,0); card.Position=UDim2.new(1,-16,0,16); card.Size=UDim2.fromOffset(300,52); card.BackgroundColor3=c.Surface; card.TextColor3=c.Text; card.Font=t.Fonts.Main; card.TextSize=12; card.TextWrapped=true; card.Text=type(o.Text)=="string" and o.Text or "Notification"; card.Parent=self.Gui
    local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,8); corner.Parent=card
    self.Card=card; task.delay(math.max(.5,tonumber(o.Duration) or 3),function() if not self._destroyed then self:Destroy() end end)
    return self
end
function Notification:Destroy() if self._destroyed then return end self._destroyed=true; if self.Gui then self.Gui:Destroy() end end
return Notification
