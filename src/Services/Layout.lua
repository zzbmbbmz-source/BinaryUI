local Layout={}
function Layout.List(parent,padding)
    local x=Instance.new("UIListLayout"); x.Padding=UDim.new(0,padding or 6); x.SortOrder=Enum.SortOrder.LayoutOrder; x.Parent=parent; return x
end
function Layout.Padding(parent,p)
    local x=Instance.new("UIPadding"); x.PaddingTop=UDim.new(0,p or 0); x.PaddingBottom=UDim.new(0,p or 0); x.PaddingLeft=UDim.new(0,p or 0); x.PaddingRight=UDim.new(0,p or 0); x.Parent=parent; return x
end
return Layout
