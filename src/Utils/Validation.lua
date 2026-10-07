local Validation = {}

function Validation.string(value, fallback)
    return type(value)=="string" and value or fallback
end

function Validation.boolean(value, fallback)
    return type(value)=="boolean" and value or fallback
end

function Validation.number(value, fallback)
    return type(value)=="number" and value or fallback
end

function Validation.callback(value)
    return type(value)=="function" and value or function() end
end

function Validation.table(value)
    return type(value)=="table" and value or {}
end

return Validation
