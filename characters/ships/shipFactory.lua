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
    ship.moving_dir = newVector2()
    ship.base_speed = base_speed or 100
    ship.speed = ship.base_speed
    ship.lerp_speed = lerp_speed or 5
    ship.base_sprite = newSprite(img)
    ship.engine = newEngine(engine)
    ship.weapon = newWeapon(cannon, group)

    ship.health = health or 20
    ship.is_dead = false
    ship.can_get_hit = true
    ship.invincibility_timer = newTimer(0.1)
    ship.hitbox_radius = hitbox_radius or 20

    ship.bullet_speed_increase = 0
    ship.bullet_damage_increase = 0
    ship.shooting_speed_increase = 0

    ship.shoot = function()
        ship.weapon.shoot()
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
        end
    end

    
    ship.update_invincibility_timer = function(dt)
        if ship.invincibility_timer.update(dt) then
            ship.can_get_hit = true
        end
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

    local function draw_state()
        if ship.stateMachine then
            love.graphics.print(tostring(ship.stateMachine.state), ship.pos.x-10, ship.pos.y-50)
        end
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
        draw_state()

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