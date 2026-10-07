local RateLimiter={}
RateLimiter.__index=RateLimiter
function RateLimiter.new(interval) return setmetatable({Interval=math.max(0,tonumber(interval) or .05),Last=0},RateLimiter) end
function RateLimiter:Allow()
    local now=os.clock()
    if now-self.Last<self.Interval then return false end
    self.Last=now; return true
end
return RateLimiter
