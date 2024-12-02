
local trigger_img_width = 96
local triggerImg = newQuadSprite(
    "assets/Void_EnvironmentPack/Planets/PNGs/Earth-Like planet - Without back glow.png",
    77,
    1,
    trigger_img_width,
    trigger_img_width,
    450,
    {r=0.5, g=0, b=0.8}
)
local trigger_scale = 2
local trigger_radius = trigger_img_width*trigger_scale*0.2

local newSurvivorTriger = function(pos)
    local trigger = newTrigger(
        pos or newVector2(),
        triggerImg,
        newVector2(),
        newVector2(trigger_scale,trigger_scale),
        trigger_radius,
        "A Vortex Was Created \n Enter it to return to survival Arena"

    )
    return trigger
end
return newSurvivorTriger
