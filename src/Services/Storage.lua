local HttpService=game:GetService("HttpService")
local Storage={}
function Storage.Encode(value) local ok,result=pcall(function() return HttpService:JSONEncode(value) end); return ok and result or nil end
function Storage.Decode(value) local ok,result=pcall(function() return HttpService:JSONDecode(value) end); return ok and result or nil end
return Storage
