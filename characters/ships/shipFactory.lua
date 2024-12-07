require("characters.components.engines")
require("characters.components.projectiles")
require("characters.components.weapons")
require("characters.components.pickups")
require("characters.components.destruction")

SHIP_GROUPS = {}
SHIP_GROUPS.ENEMY = "enemy"
SHIP_GROUPS.PLAYER = "player"

function newShip(group, img, engine, cannon, health, hitbox_radius, base_speed, lerp_speed, pos, rad, destruction_animation)
    local ship = {}
    ship.pos = pos or newVector2(ScaledScreenWidth/2, ScaledScreenHeight/2)
    ship.rad = rad or 0
    ship.group = group
    ship.moving_dir = newVector2()
    ship.base_speed = base_speed or 100
    ship.speed = ship.base_speed
    ship.lerp_speed = lerp_speed or 5
    ship.base_sprite = newSprite(img)
    ship.engine = newEngine(engine)
    ship.weapon = newWeapon(cannon, ship.group)
    if destruction_animation then
        ship.destruction_animation = newDestructionAnimation(destruction_animation)
    end

    ship.max_health = health or 20
    ship.health = ship.max_health
    ship.is_dead = false
    ship.death_animation_finished = false
    ship.can_get_hit = true
    ship.invicible = false
    ship.invincibility_timer = newTimer(0.1)
    ship.blink_timer = newTimer(0.1, false)
    ship.hitbox_radius = hitbox_radius or 20

    ship.base_max_boost_energy = 100
    ship.max_boost_energy = ship.base_max_boost_energy
    ship.boost_energy = ship.max_boost_energy
    ship.boost_energy_consumption = 50
    ship.boost_factor = 1.5
    ship.is_boosting = false
    ship.boost_recharge_factor = 0

    ship.energy_bar_size = newVector2(60, 10)
    ship.energy_bar_size_filed = 1
    ship.boost_activated = false

    local life_bar_width = 40
    local life_bar_height = 10
    ship.life_bar_size = newVector2(life_bar_width,life_bar_height)
    ship.life_bar_size_filed = 1

    ship.bullet_speed_increase = 0
    ship.bullet_damage_increase = 0
    ship.shots_per_sec_increase = 0
    ship.boost_increase = 0
    ship.health_increase = 0
    ship.touched_width_limit = false
    ship.touched_height_limit = false

    ship.damage_sound = nil

    ship.show = true


    ship.constrain_ship_pos = function ()
        if MovingCamera == false then
            ship.touched_width_limit = false
            ship.touched_height_limit = false
            if ship.pos.x - ship.base_sprite.width * 0.5  < 0 then
                ship.pos.x = ship.base_sprite.width * 0.5
                ship.touched_width_limit = true
            elseif ship.pos.x + ship.base_sprite.width * 0.5 > ScaledScreenWidth then
                ship.pos.x = ScaledScreenWidth - ship.base_sprite.width * 0.5
                ship.touched_width_limit = true
            end
            if ship.pos.y - ship.base_sprite.height * 0.5  < 0 then
                ship.pos.y = ship.base_sprite.height * 0.5
                ship.touched_height_limit = true
            elseif ship.pos.y + ship.base_sprite.height * 0.5 > ScaledScreenHeight then
                ship.pos.y = ScaledScreenHeight - ship.base_sprite.height * 0.5
                ship.touched_height_limit = true
            end
        end
        
    end

    ship.shoot = function()
        ship.weapon.shoot()
    end

    ship.heal = function(added_health)
        ship.health = math.min(ship.max_health, ship.health + added_health)
    end

    ship.increase_max_health = function(added_health)
        ship.health_increase = ship.health_increase + added_health
        ship.max_health = ship.max_health + added_health
        ship.health = ship.health + added_health
    end

    ship.increase_max_boost = function(added_boost)
        ship.boost_increase = ship.boost_increase + added_boost
        ship.max_boost_energy = ship.base_max_boost_energy + math.floor(ship.base_max_boost_energy * ship.boost_increase / 100)
    end

    ship.increase_fire_rate = function(added_speed)
        ship.shots_per_sec_increase = ship.shots_per_sec_increase + added_speed
        ship.weapon.shots_per_sec = ship.weapon.base_shots_per_sec + ship.weapon.base_shots_per_sec * ship.shots_per_sec_increase / 100
        ship.weapon.current_base_sprite.fps = ship.weapon.current_base_sprite.nframes * ship.weapon.shots_per_sec

    end

    ship.increase_damage = function(added_damage)
        ship.bullet_damage_increase = ship.bullet_damage_increase + added_damage
        ship.weapon.bullet_damage =ship.weapon.bullet_base_damage + math.floor(ship.weapon.bullet_base_damage * ship.bullet_damage_increase / 100)
    end

    ship.increase_projectile_speed = function(added_speed)
        ship.bullet_speed_increase = ship.bullet_speed_increase + added_speed
        ship.weapon.bullet_speed = ship.weapon.bullet_base_speed + math.floor(ship.weapon.bullet_base_speed*ship.bullet_speed_increase/100)
    end

    ship.upgrade_weapon = function(upgrade_type, ugrade_value)
        if upgrade_type == UPGRADE_SHOOTING_SPEED then
            ship.increase_fire_rate(ugrade_value)
        elseif upgrade_type == UPGRADE_DAMAGE then
            ship.increase_damage(ugrade_value)
        elseif upgrade_type == UPGRADE_PROJECTILE_SPEED then
            ship.increase_projectile_speed(ugrade_value)
        elseif upgrade_type == UPGRADE_INCREASE_HEALTH then
            ship.increase_max_health(ugrade_value)
        elseif upgrade_type == UPGRADE_HEAL then
            ship.heal(ugrade_value)
        elseif upgrade_type == UPGRADE_MAX_BOOST then
            ship.increase_max_boost(ugrade_value)
        end
    end

    
    ship.update_invincibility_timer = function(dt)
        if ship.invincibility_timer.update(dt) then
            ship.can_get_hit = true
        end
    end

    ship.boost = function(dt)
        ship.speed = ship.base_speed
        if ship.is_boosting == true then
            ship.boost_recharge_factor = 0
            if ship.boost_energy > 0 then
                ship.boost_energy = ship.boost_energy - ship.boost_energy_consumption * dt
                ship.speed = ship.base_speed * ship.boost_factor
            end
        else
            ship.boost_recharge_factor = ship.boost_recharge_factor + 1 * dt
            ship.boost_energy = math.min(ship.max_boost_energy, ship.boost_energy + ship.boost_recharge_factor * ship.boost_energy_consumption * dt)
        end
        ship.energy_bar_size_filed = ship.boost_energy/ship.max_boost_energy
    end

    ship.move_and_look_at = function(dist_pos, dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos,dist_pos, ship.rad, ship.lerp_speed, dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end

    ship.move_to = function(dist_pos, dt)
        local target_rad = math.angle(ship.pos.x, ship.pos.y, dist_pos.x, dist_pos.y)
        ship.moving_dir = newVector2FromRad(target_rad)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end

    ship.look_at = function(dist_pos, dt)
        local moving_dir
        ship.rad, moving_dir = SmoothLookAt(ship.pos, dist_pos, ship.rad, ship.lerp_speed, dt)
    end

    ship.update_blink_timer = function(dt)
        if ship.blink_timer.update(dt) then
            ship.show = not ship.show
            ship.blink_timer.start()
        end
    end

    ship.update_death_animation = function(dt)
        if ship.death_animation_finished == false and ship.is_dead == true and ship.destruction_animation then
            ship.destruction_animation.update(dt)
            if ship.destruction_animation.img.play_sprite == false then
                ship.death_animation_finished = true
            end
        end
    end

    ship.update = function(dt)
        if ship.is_dead == false then
            ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
            ship.engine.update(0, dt)
            ship.shoot()
            ship.weapon.update(dt, ship.pos, ship.rad)
            ship.update_invincibility_timer(dt)
            ship.update_blink_timer(dt)
        else
            ship.update_death_animation(dt)
        end

    end

    ship.draw_health = function()
        local font = love.graphics.newFont(12)  -- Choose your font size
        love.graphics.setFont(font)
        local x_pos = ship.pos.x-ship.life_bar_size.x*0.5
        local y_pos = ship.pos.y-30
        local text = tostring(ship.health).."/"..tostring(ship.max_health)
        local textWidth = font:getWidth(text)
        ship.life_bar_size.x = math.max(ship.life_bar_size.x, textWidth)
        local textHeight = font:getHeight(text)
        local text_x_pos = ship.pos.x - textWidth * 0.5
        local text_y_pos = y_pos-2

        love.graphics.setColor(1,0,0,0.6)
        love.graphics.rectangle("line", x_pos, y_pos, ship.life_bar_size.x, ship.life_bar_size.y)
        love.graphics.rectangle("fill", x_pos, y_pos, ship.life_bar_size.x*(ship.health/ship.max_health), ship.life_bar_size.y)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(text, text_x_pos, text_y_pos)
        love.graphics.setFont(Font)
    end

    local function draw_boost()
        love.graphics.setColor(0,1,0,0.4)
        love.graphics.rectangle("line", ship.pos.x-ship.energy_bar_size.x*0.5, ship.pos.y+30, ship.energy_bar_size.x, ship.energy_bar_size.y)
        love.graphics.rectangle("fill", ship.pos.x-ship.energy_bar_size.x*0.5, ship.pos.y+30, ship.energy_bar_size.x*ship.energy_bar_size_filed, ship.energy_bar_size.y)
        love.graphics.setColor(1,1,1,1)
    end

    ship.draw_state = function()
    end


    local function draw_hitbox()
        love.graphics.circle("line", ship.pos.x, ship.pos.y, ship.hitbox_radius)
    end

    ship.draw_death_animation = function(new_pos, new_rad)
        if ship.destruction_animation and ship.is_dead then
            ship.destruction_animation.draw(new_pos, new_rad)
        end
    end

    ship.draw = function()
        
        if ship.color then
            love.graphics.setColor(ship.color.r, ship.color.g, ship.color.b)
        end
        if ship.show == true and ship.is_dead == false then
            ship.base_sprite.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
            ship.engine.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
            ship.weapon.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        end
        if ship.color then
            love.graphics.setColor(1, 1, 1)
        end
        if ship.is_dead == false then
            ship.draw_health()
        end
        --draw_hitbox()
        --ship.draw_state()
        if ship.boost_activated == true then
            draw_boost()
        end
        ship.draw_death_animation(ship.pos, ship.rad + IMG_RAD_OFFSET)
        
    end

    ship.common_death_process = function()
        ship.is_dead = true
        if ship.destruction_animation then
            ship.destruction_animation.img.play_sprite = true
        end
    end
    
    ship.die = function()
        ship.common_death_process()
    end

    local function take_damage(damage)
        if ship.damage_sound then
            PlaySound(ship.damage_sound, 0.1)
        end
        ship.health = ship.health - damage
        if ship.health <= 0 then
            ship.health = 0
            ship.die()
        end
    end

    ship.hit = function(damage)
        if ship.can_get_hit == true then
            ship.can_get_hit = false
            ship.invincibility_timer.start()
            take_damage(damage)
        end
    end

    ship.turn_invincible = function()
        ship.invicible = true
        ship.can_get_hit = false
        ship.color = newColor(255,0,0)
        ship.blink_timer.start()

    end
    
    ship.turn_vulnerable = function()
        ship.invicible = false
        ship.show = true
        ship.can_get_hit = true
        ship.color = newColor(255,255,255)
        ship.blink_timer.stop()
    end

    return ship
end