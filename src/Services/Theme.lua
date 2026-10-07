local Theme = {}
Theme.__index = Theme

local function merge(base, patch)
    local result = table.clone(base)
    if type(patch) == "table" then
        for k,v in pairs(patch) do
            if type(v)=="table" and type(result[k])=="table" then
                result[k]=merge(result[k],v)
            else
                result[k]=v
            end
        end
    end
    return result
end

function Theme.new(defaults)
    return setmetatable({_theme=table.clone(defaults or {})}, Theme)
end

function Theme:Get()
    return table.clone(self._theme)
end

function Theme:Set(patch)
    self._theme=merge(self._theme, patch)
end

function Theme:Color(name)
    return self._theme.Colors and self._theme.Colors[name] or Color3.new(1,1,1)
end

return Theme
