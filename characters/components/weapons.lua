local weapon_sprite_params = require("characters.components.weapons_config")


local function create_weapon_sprite(params)
    return newQuadSprite(
        params.img,
        params.cquad,
        params.lquad,
        params.wquad,
        params.hquad,
        params.fps,
        {r=1, g=1, b=1},
        SPRITE_PLAY_ONCE
    )
end


function newWeapon(type, group)
    local weapon = {}
    weapon.current_base_sprite = create_weapon_sprite(weapon_sprite_params[type])
    weapon.type = type
    weapon.bullet_type = weapon_sprite_params[type].bullet_type
    weapon.bullet_base_speed = weapon_sprite_params[type].bullet_base_speed
    weapon.bullet_speed = weapon.bullet_base_speed
    weapon.bullet_base_damage = weapon_sprite_params[type].bullet_base_damage
    weapon.bullet_damage = weapon.bullet_base_damage
    weapon.base_shooting_speed = weapon_sprite_params[type].fps
    weapon.bullet_speed_increase = 0
    weapon.bullet_damage_increase = 0
    weapon.shooting_speed_increase = 0
    weapon.shooting_frames = weapon_sprite_params[type].shooting_frames
    weapon.group = group or "player"

    weapon.reset = function()
        weapon.current_base_sprite.reset()
        weapon.has_shot = {}
        weapon.can_shoot = true
        weapon.will_shoot = false
        weapon.shot_fired = 0
    end

    weapon.reset()



    weapon.increase_fire_rate = function(added_speed)
        weapon.shooting_speed_increase = weapon.shooting_speed_increase + added_speed
        weapon.current_base_sprite.fps = weapon.base_shooting_speed + math.floor(weapon.base_shooting_speed * weapon.shooting_speed_increase / 100)
    end

    weapon.increase_damage = function(added_damage)
        weapon.bullet_damage_increase = weapon.bullet_damage_increase + added_damage
        weapon.bullet_damage =weapon.bullet_base_damage + math.floor(weapon.bullet_base_damage * weapon.bullet_damage_increase / 100)
    end

    weapon.increase_projectile_speed = function(added_speed)
        weapon.bullet_speed_increase = weapon.bullet_speed_increase + added_speed
        weapon.bullet_speed = weapon.bullet_base_speed + math.floor(weapon.bullet_base_speed*weapon.bullet_speed_increase/100)
    end


    weapon.shoot = function()
        if weapon.can_shoot then
            weapon.current_base_sprite.play_sprite = true
            weapon.can_shoot = false
            weapon.will_shoot = true
            weapon.shot_fired = 0
            for i, elem in ipairs(weapon.shooting_frames) do
                weapon.has_shot[i] = false
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
                if weapon.current_base_sprite.frame == weapon.shooting_frames[i].frame and weapon.has_shot[i] == false then
                    newProjectile(
                        weapon.bullet_type,
                        pos + weapon.shooting_frames[i].offset.rotate(rad + IMG_RAD_OFFSET),
                        rad,
                        weapon.bullet_speed,
                        weapon.group,
                        weapon.bullet_damage
                    )
                    weapon.has_shot[i] = true
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