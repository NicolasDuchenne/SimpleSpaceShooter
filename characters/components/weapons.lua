require("characters.components.projectiles")

AUTO_CANNON = "auto_cannon"
BIG_SPACE_GUN = "big_space_gun"
ROCKETS = "rockets"
ZAPPER = "zapper"

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
weapon_sprite_params[AUTO_CANNON] = {
    img ="assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Auto Cannon.png",
    cquad = 7,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 16,
    bullet_type = AUTO_CANNON_PROJECTILE,
    bullet_speed = 400,
    shooting_frames = {
        {
            frame = 2,
            offset = newVector2(10,0)
        },
        {
            frame = 3,
            offset = newVector2(-10,0)
        }
    }
}

weapon_sprite_params[BIG_SPACE_GUN] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Big Space Gun.png",
    cquad = 12,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 16,
    bullet_type = BIG_SPACE_GUN_PROJECTILE,
    bullet_speed = 300,
    shooting_frames = {
        {
            frame = 7,
            offset = newVector2(0,-20)
        }
    }
}

weapon_sprite_params[ROCKETS] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - ROCKETS.png",
    cquad = 17,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 16,
    bullet_type = ROCKETS_PROJECTILE,
    bullet_speed = 300,
    shooting_frames = {
        {
            frame = 3,
            offset = newVector2(-5,0)
        },
        {
            frame = 5,
            offset = newVector2(5,0)
        },
        {
            frame = 7,
            offset = newVector2(-10,5)
        },
        {
            frame = 9,
            offset = newVector2(10,5)
        },
        {
            frame = 11,
            offset = newVector2(-15,10)
        },
        {
            frame = 13,
            offset = newVector2(15,10)
        },
        
    }
}

weapon_sprite_params[ZAPPER] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Zapper.png",
    cquad = 14,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 16,
    bullet_type = ZAPPER_PROJECTILE,
    bullet_speed = 300,
    shooting_frames = {
        {
            frame = 5,
            offset = newVector2(8,-20)
        },
        {
            frame = 5,
            offset = newVector2(-8,-20)
        },
    }
}

for type, params in pairs(weapon_sprite_params) do
    params.sprite = create_weapon_sprite(params)
end

function newWeapon(type)
    local weapon = {}
    weapon.can_shoot = true
    weapon.will_shoot = false
    weapon.shot_fired = 0


    weapon.set_type = function(type)
        weapon.type = type
        weapon.current_base_sprite = weapon_sprite_params[weapon.type].sprite
        weapon.bullet_type = weapon_sprite_params[type].bullet_type
        weapon.bullet_speed = weapon_sprite_params[type].bullet_speed
        weapon.shooting_frames = weapon_sprite_params[type].shooting_frames
        weapon.current_base_sprite.reset()
    end

    weapon.set_type(type)

    weapon.shoot = function()
        if weapon.can_shoot then
            weapon.current_base_sprite.play_sprite = true
            weapon.can_shoot = false
            weapon.will_shoot = true
            weapon.shot_fired = 0
            for i, elem in ipairs(weapon.shooting_frames) do
                elem.has_shot = false
            end
        end
    end

    weapon.update = function(dt, pos, rad)
        weapon.current_base_sprite.update(dt)
        if weapon.current_base_sprite.play_sprite == false then
            weapon.can_shoot = true
        end
        if weapon.will_shoot then
            for i= 1, #weapon.shooting_frames do
                if weapon.current_base_sprite.frame == weapon.shooting_frames[i].frame and weapon.shooting_frames[i].has_shot == false then
                    newProjectile(
                        weapon.bullet_type,
                        pos + weapon.shooting_frames[i].offset.rotate(rad + IMG_RAD_OFFSET),
                        rad,
                        weapon.bullet_speed
                    )
                    weapon.shooting_frames[i].has_shot = true
                    weapon.shot_fired = weapon.shot_fired + 1
                end

            end
            if weapon.shot_fired == #weapon.shooting_frames then
                weapon.will_shoot = false
            end
        end
    end

    weapon.draw = function(pos, rad)
        weapon.current_base_sprite.draw(pos, rad)
    end

    return weapon
end