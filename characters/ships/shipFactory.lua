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
    ship.invinsibility_timer = 0
    ship.invinsibility_duration = 0.1
    ship.hitbox_radius = hitbox_radius or 20

    ship.shoot = function()
        ship.weapon.shoot()
    end
    
    ship.update_hit_timer = function(dt)
        if ship.can_get_hit == false then
            ship.invinsibility_timer = ship.invinsibility_timer + dt
            if ship.invinsibility_timer > ship.invinsibility_duration then
                ship.can_get_hit = true
                ship.invinsibility_timer = 0
            end
        end
    end

    ship.update = function(dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        ship.engine.update(0, dt)
        ship.shoot()
        ship.weapon.update(dt, ship.pos, ship.rad)
        ship.update_hit_timer(dt)
        
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
            ship.can_get_hit = false
            take_damage(damage)
        end
    end

    return ship
end