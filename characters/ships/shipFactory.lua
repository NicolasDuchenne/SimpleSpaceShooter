require("characters.components.engines")
require("characters.components.projectiles")
require("characters.components.weapons")
require("characters.components.pickups")

function newShip(img, engine, cannon, pos, rad, base_speed, lerp_speed)
    local ship = {}
    ship.pos = pos or newVector2(ScreenWidth/2, ScreenHeight/2)
    ship.rad = rad or 0
    ship.moving_dir = newVector2()
    ship.base_speed = base_speed or 100
    ship.speed = ship.base_speed
    ship.lerp_speed = lerp_speed or 5
    ship.base_sprite = newSprite(img)
    ship.engine = newEngine(engine)
    ship.weapon = newWeapon(cannon)

    ship.shoot = function()
        ship.weapon.shoot()
    end

    ship.update = function(dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        ship.engine.update(0, dt)
        ship.shoot()
        ship.weapon.update(dt, ship.pos, ship.rad)
    end

    ship.draw = function()
        ship.base_sprite.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        ship.engine.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
        ship.weapon.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
    end



    return ship
end