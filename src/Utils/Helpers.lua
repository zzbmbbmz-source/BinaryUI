local Helpers={}
function Helpers.ClampNumber(v,min,max,default) if type(v)~="number" then return default end return math.clamp(v,min,max) end
function Helpers.Copy(t) return type(t)=="table" and table.clone(t) or t end
function Helpers.SafeName(name,fallback) if type(name)~="string" or name=="" then return fallback end return name:gsub("[^%w_%-]","_") end
return Helpers
