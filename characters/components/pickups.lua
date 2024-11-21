local pickups_sprite_params = require("characters.components.pickups_config")


local function create_pickups_sprite(params, size)
    return newQuadSprite(
        params.img,
        params.cquad,
        params.lquad,
        params.wquad,
        params.hquad,
        params.fps

    )
end

function newPickup(type)
    local pickup = {}
    pickup.sprite = create_pickups_sprite(pickups_sprite_params[type])
    return pickup
end
