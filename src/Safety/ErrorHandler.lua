local ErrorHandler = {}
ErrorHandler.__index = ErrorHandler

function ErrorHandler.new(debugMode)
    return setmetatable({_debug=debugMode==true, _count=0, _last=nil}, ErrorHandler)
end

function ErrorHandler:Report(source, err)
    self._count += 1
    self._last = {Source=tostring(source), Error=tostring(err)}
    if self._debug then
        warn("[BinaryUI]["..self._last.Source.."] "..self._last.Error)
    end
end

function ErrorHandler:GetDiagnostics()
    return {Errors=self._count, Last=self._last}
end

return ErrorHandler
