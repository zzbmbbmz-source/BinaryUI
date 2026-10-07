local Recovery = {}

function Recovery.Try(handler, source, callback, fallback)
    local ok, result = xpcall(callback, debug.traceback)
    if ok then return true, result end
    if handler then handler:Report(source, result) end
    if fallback then pcall(fallback, result) end
    return false, nil
end

return Recovery
