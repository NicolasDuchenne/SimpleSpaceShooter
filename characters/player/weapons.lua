AUTO_CANNON = "auto_cannon"
BIG_SPACE_GUN = "big_space_gun"

local weapon = {}
weapon.type = AUTO_CANNON


local function create_weapon_sprite(params)
    return newQuadSprite(
    params.img,
    params.cquad,
    params.lquad,
    params.wquad,
    params.hquad,
    params.fps,
    SPRITE_PLAY_ONCE
)
end

local weapon_sprite_params = {}
weapon_sprite_params[AUTO_CANNON] = {img ="assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Auto Cannon.png",cquad = 7, lquad = 1, wquad = 48, hquad = 48, fps = 8}
weapon_sprite_params[BIG_SPACE_GUN] = {img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Big Space Gun.png", cquad = 12, lquad = 1, wquad = 48, hquad = 48, fps = 8}

weapon.base_sprites = {}
weapon.base_sprites[AUTO_CANNON] = create_weapon_sprite(weapon_sprite_params[AUTO_CANNON])
weapon.base_sprites[BIG_SPACE_GUN] = create_weapon_sprite(weapon_sprite_params[BIG_SPACE_GUN])


weapon.base_sprite = weapon.base_sprites[weapon.type]

weapon.set_type = function(type)
    weapon.type = type
    weapon.base_sprite = weapon.base_sprites[weapon.type]
    weapon.base_sprite.reset()
end
weapon.update = function(dt)
    weapon.base_sprite.update(dt)
end

weapon.draw = function(pos, rad)
    weapon.base_sprite.draw(pos, rad)
end

return weapon

