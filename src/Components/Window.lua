local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Cleanup=require(script.Parent.Parent.Services.Cleanup)
local ConnectionGuard=require(script.Parent.Parent.Safety.ConnectionGuard)
local SafeCall=require(script.Parent.Parent.Safety.SafeCall)
local Defaults=require(script.Parent.Parent.Utils.Defaults)
local Signal=require(script.Parent.Parent.Core.Signals)

local Window={}
Window.__index=Window
local nextId=0

local function make(class,parent,props)
    local x=Instance.new(class)
    x.Parent=parent
    for k,v in pairs(props or {}) do x[k]=v end
    return x
end

function Window.new(core,theme,errors,options)
    options=type(options)=="table" and options or {}
    nextId+=1
    local self=setmetatable({},Window)
    self._id="Window_"..nextId
    self._core=core; self._theme=theme; self._errors=errors
    self._cleanup=Cleanup.new(); self._connections=ConnectionGuard.new()
    self.Destroyed=Signal.new()
    self._destroyed=false
    local player=Players.LocalPlayer
    local parent=player and player:FindFirstChildOfClass("PlayerGui")
    if not parent then error("BinaryUI requires LocalPlayer.PlayerGui") end
    local c=theme:Get().Colors
    self.Gui=make("ScreenGui",parent,{Name="BinaryUI_"..nextId,ResetOnSpawn=false,IgnoreGuiInset=false,ZIndexBehavior=Enum.ZIndexBehavior.Sibling})
    self._cleanup:Add(self.Gui)
    self.Main=make("Frame",self.Gui,{Name="Window",AnchorPoint=Vector2.new(.5,.5),Position=UDim2.fromScale(.5,.5),Size=options.Size or Defaults.Window.Size,BackgroundColor3=c.Background,BorderSizePixel=0,Active=true})
    make("UICorner",self.Main,{CornerRadius=UDim.new(0,theme:Get().Corner)})
    make("UIStroke",self.Main,{Color=c.Accent,Thickness=1,Transparency=.65})
    self.Header=make("TextButton",self.Main,{Name="Header",Text="",Size=UDim2.new(1,0,0,48),BackgroundTransparency=1,AutoButtonColor=false})
    self.Title=make("TextLabel",self.Header,{Text=options.Title or Defaults.Window.Title,Font=theme:Get().Fonts.Main,TextSize=17,TextColor3=c.Text,BackgroundTransparency=1,Position=UDim2.fromOffset(16,7),Size=UDim2.new(1,-32,0,20),TextXAlignment=Enum.TextXAlignment.Left})
    self.Subtitle=make("TextLabel",self.Header,{Text=options.Subtitle or Defaults.Window.Subtitle,Font=theme:Get().Fonts.Main,TextSize=11,TextColor3=c.Muted,BackgroundTransparency=1,Position=UDim2.fromOffset(16,27),Size=UDim2.new(1,-32,0,16),TextXAlignment=Enum.TextXAlignment.Left})
    self.Content=make("ScrollingFrame",self.Main,{Name="Content",Position=UDim2.fromOffset(12,58),Size=UDim2.new(1,-24,1,-70),BackgroundTransparency=1,BorderSizePixel=0,AutomaticCanvasSize=Enum.AutomaticSize.Y,CanvasSize=UDim2.new(),ScrollBarThickness=4})
    make("UIPadding",self.Content,{PaddingLeft=UDim.new(0,4),PaddingRight=UDim.new(0,4),PaddingTop=UDim.new(0,4),PaddingBottom=UDim.new(0,12)})
    make("UIListLayout",self.Content,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
    self:_bindDrag()
    self:_bindResize()
    return self
end

function Window:GetId() return self._id end
function Window:_bindDrag()
    local dragging=false; local startPos; local startInput
    self._connections:Add(self.Header.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; startInput=input.Position; startPos=self.Main.Position
        end
    end))
    self._connections:Add(UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-startInput
            self.Main.Position=startPos+UDim2.fromOffset(d.X,d.Y)
        end
    end))
    self._connections:Add(UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
    end))
end

function Window:_bindResize()
    local handle=Instance.new("TextButton")
    handle.Name="ResizeHandle"; handle.Text=""; handle.AutoButtonColor=false; handle.BackgroundTransparency=1
    handle.AnchorPoint=Vector2.new(1,1); handle.Position=UDim2.fromScale(1,1); handle.Size=UDim2.fromOffset(24,24); handle.Parent=self.Main
    local resizing=false; local startInput; local startSize
    self._connections:Add(handle.InputBegan:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then resizing=true; startInput=input.Position; startSize=self.Main.AbsoluteSize end
    end))
    self._connections:Add(UIS.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
            local d=input.Position-startInput
            local min=Defaults.Window.MinSize
            self.Main.Size=UDim2.fromOffset(math.max(min.X,startSize.X+d.X),math.max(min.Y,startSize.Y+d.Y))
        end
    end))
    self._connections:Add(UIS.InputEnded:Connect(function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then resizing=false end
    end))
end

function Window:AddTab(options)
    local Tab=require(script.Tab)
    return Tab.new(self,options or {})
end

function Window:RefreshTheme()
    if self._destroyed then return end
    local c=self._theme:Get().Colors
    self.Main.BackgroundColor3=c.Background
    self.Title.TextColor3=c.Text
    self.Subtitle.TextColor3=c.Muted
end

function Window:Destroy()
    if self._destroyed then return end
    self._destroyed=true
    self._connections:Cleanup()
    self._cleanup:Destroy()
    self.Destroyed:Fire()
    self.Destroyed:Destroy()
    if self._core then self._core.Registry:Remove(self._id) end
end

return Window
