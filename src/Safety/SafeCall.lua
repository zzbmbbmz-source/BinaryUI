local SafeCall = {}

function SafeCall.run(handler, callback, ...)
    if type(callback) ~= "function" then
        return true
    end
    local ok, result = xpcall(function(...)
        return callback(...)
    end, function(err)
        return debug.traceback(tostring(err), 2)
    end, ...)
    if not ok and handler then
        handler:Report("Callback", result)
    end
    return ok, result
end

return SafeCall
