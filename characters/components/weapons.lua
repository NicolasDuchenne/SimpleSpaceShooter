local weapon_sprite_params = require("characters.components.weapons_config")


local function create_weapon_sprite(params)
    local fps = params.cquad * params.shots_per_sec
    return newQuadSprite(
        params.img,
        params.cquad,
        params.lquad,
        params.wquad,
        params.hquad,
        fps,
        nil,
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
    weapon.base_shots_per_sec = weapon_sprite_params[type].shots_per_sec
    weapon.shots_per_sec = weapon.base_shots_per_sec
    weapon.bullet_speed_increase = 0
    weapon.bullet_damage_increase = 0
    weapon.shooting_speed_increase = 0
    weapon.shooting_frames = weapon_sprite_params[type].shooting_frames
    weapon.group = group or "player"
    if weapon_sprite_params[type].sound then
        weapon.sound = love.audio.newSource(weapon_sprite_params[type].sound, "static")
    end

    weapon.reset = function()
        weapon.current_base_sprite.reset()
        weapon.has_shot = {}
        weapon.can_shoot = true
        weapon.will_shoot = false
        weapon.shot_fired = 0
    end

    weapon.reset()

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
                    local rad_shoot = rad
                    if weapon.shooting_frames[i].offset_rad then
                        rad_shoot = rad_shoot + weapon.shooting_frames[i].offset_rad
                    end
                    newProjectile(
                        weapon.bullet_type,
                        pos + weapon.shooting_frames[i].offset.rotate(rad + IMG_RAD_OFFSET),
                        rad_shoot,
                        weapon.bullet_speed,
                        weapon.group,
                        weapon.bullet_damage
                    )
                    if weapon.sound then
                        PlaySound(weapon.sound, 0.1, 0.5)
                    end
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