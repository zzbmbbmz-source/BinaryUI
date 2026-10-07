local Tween=require(script.Parent.Tween)
local Animation={}
function Animation.Fade(instance,transparency,duration)
    return Tween.Play(instance,TweenInfo.new(duration or .2,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=transparency})
end
return Animation
