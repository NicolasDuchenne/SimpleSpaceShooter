PICKUPS = {}
PICKUPS.auto_cannon = "auto_cannon_pickup"
PICKUPS.big_space_gun = "big_space_gun_pickup"
PICKUPS.rockets = "rockets_pickup"
PICKUPS.zapper = "zapper_pickup"

local pickups_sprite_params = {}
pickups_sprite_params[PICKUPS.auto_cannon] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Auto Cannons.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[PICKUPS.big_space_gun] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Big Space Gun 2000.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[PICKUPS.rockets] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Rocket.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[PICKUPS.zapper] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Zapper.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

local function create_pickups_sprite(params)
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
