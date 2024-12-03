PICKUP = {}
PICKUP.boost = "pickup_boost"
PICKUP.health = "pickup_health"

local pickups_sprite_params = {}
pickups_sprite_params[WEAPONS.player.auto_cannon] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Auto Cannons.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[WEAPONS.player.big_space_gun] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Big Space Gun 2000.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[WEAPONS.player.rockets] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Rocket.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[WEAPONS.player.zapper] = {
    img = "assets/Void_PickupsPack/Weapons/PNGs/Pickup Icon - Weapons - Zapper.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[PICKUP.boost] = {
    img = "assets/Void_PickupsPack/Engines/PNGs/Pickup Icon - Engines - Base Engine.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

pickups_sprite_params[PICKUP.health] = {
    img = "assets/Void_PickupsPack/Shield Generators/PNGs/Pickup Icon - Shield Generator - All around shield.png",
    cquad = 15,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 24
}

return pickups_sprite_params