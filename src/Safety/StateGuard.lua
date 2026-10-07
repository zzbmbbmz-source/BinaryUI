local StateGuard={}
function StateGuard.Wrap(setter,validator)
    return function(value,...)
        if type(validator)=="function" then local ok=pcall(validator,value); if not ok then return false end end
        local ok=pcall(setter,value,...); return ok
    end
end
return StateGuard
