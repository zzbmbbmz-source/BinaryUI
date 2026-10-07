local Math={}
function Math.Remap(v,a,b,c,d) if a==b then return c end return c+(v-a)/(b-a)*(d-c) end
function Math.Round(v,decimals) local p=10^(decimals or 0); return math.floor(v*p+.5)/p end
return Math
