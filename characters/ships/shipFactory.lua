require("characters.components.engines")
require("characters.components.projectiles")
require("characters.components.weapons")
require("characters.components.pickups")

SHIP_GROUPS = {}
SHIP_GROUPS.ENEMY = "enemy"
SHIP_GROUPS.PLAYER = "player"

function newShip(group, img, engine, cannon, health, hitbox_radius, base_speed, lerp_speed, pos, rad)
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

    
    ship.health = health or 20
    ship.is_dead = false
    ship.can_get_hit = true
    ship.invincibility_timer = newTimer(0.1)
    ship.hitbox_radius = hitbox_radius or 20

    ship.base_max_boost_energy = 100
    ship.max_boost_energy = ship.base_max_boost_energy
    ship.boost_energy = ship.max_boost_energy
    ship.boost_energy_consumption = 50
    ship.boost_factor = 1.5
    ship.is_boosting = false
    ship.boost_recharge_factor = 0
    ship.energy_bar_size = newVector2(60,10)
    ship.energy_bar_size_filed = 1
    ship.boost_activated = false

    ship.bullet_speed_increase = 0
    ship.bullet_damage_increase = 0
    ship.shooting_speed_increase = 0
    ship.boost_increase = 0
    ship.health_increase = 0
    ship.touched_width_limit = false
    ship.touched_height_limit = false

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
        ship.health_increase = ship.health_increase + added_health
        ship.health = ship.health + added_health
    end

    ship.increase_max_boost = function(added_boost)
        ship.boost_increase = ship.boost_increase + added_boost
        ship.max_boost_energy = ship.base_max_boost_energy + math.floor(ship.base_max_boost_energy * ship.boost_increase / 100)
    end

    ship.increase_fire_rate = function(added_speed)
        ship.shooting_speed_increase = ship.shooting_speed_increase + added_speed
        ship.weapon.current_base_sprite.fps = ship.weapon.base_shooting_speed + math.floor(ship.weapon.base_shooting_speed * ship.shooting_speed_increase / 100)
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

    ship.update = function(dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        ship.engine.update(0, dt)
        ship.shoot()
        ship.weapon.update(dt, ship.pos, ship.rad)
        ship.update_invincibility_timer(dt)
        
    end

    local function draw_health()
        love.graphics.print(tostring(ship.health), ship.pos.x-10, ship.pos.y-30)
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

    ship.draw = function()
        ship.base_sprite.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        ship.engine.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        ship.weapon.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        draw_health()
        draw_hitbox()
        ship.draw_state()
        if ship.boost_activated == true then
            draw_boost()
        end
    end
    
    ship.die = function()
        ship.is_dead = true
    end

    local function take_damage(damage)
        ship.health = ship.health - damage
        if ship.health <= 0 then
            ship.health = 0
            ship.die()
        end
    end

    ship.hit = function(damage)
        if ship.can_get_hit == true then
            ship.invincibility_timer.start()
            take_damage(damage)
        end
    end

    return ship
end