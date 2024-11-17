local ship = {}
ship.pos = newVector2(ScreenWidth/2, ScreenHeight/2)
ship.rad = 0
ship.image_rad_offset = math.pi/2
ship.base_speed = 100
ship.speed = ship.base_speed
ship.base_sprite = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png")
ship.engine = require("characters.player.engines")
ship.weapon = require("characters.player.weapons")

ship.update = function(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    --ship.rad = math.angle(ship.pos.x, ship.pos.y, mouseX, mouseY)
    --ship does not move in screen because the camera follows the ship so we calculate the angle like this
    ship.rad = math.angle(ScreenWidth * 0.5 * SCALE, ScreenHeight * 0.5 * SCALE, mouseX, mouseY) 

    local dir = newVector2(math.cos(ship.rad), math.sin(ship.rad))

    local up_engine_dir = 0
    --up down thrust
    if love.keyboard.isScancodeDown("w") then
        up_engine_dir = up_engine_dir + 1
    end
    if love.keyboard.isScancodeDown("s") then
        up_engine_dir = up_engine_dir -1
    end
    local up_dir = up_engine_dir * dir


    --left right thrust
    dir = dir.rotate(math.pi/2)
    local side_engine_dir = 0
    if love.keyboard.isScancodeDown("d") then
        side_engine_dir = side_engine_dir + 1
    end
    if love.keyboard.isScancodeDown("a") then
        side_engine_dir = side_engine_dir -1
    end
    local side_dir = side_engine_dir  * dir

    local final_dir = (up_dir + side_dir).normalize()
    ship.pos = ship.pos + final_dir * ship.speed * dt

    -- Manage engines
    if love.keyboard.isScancodeDown("lshift") then
        ship.engine.set_type(BURST_ENGINE)
        ship.speed = ship.base_speed * 2
    else
        ship.engine.set_type(BASE_ENGINE)
        ship.speed = ship.base_speed
    end
    ship.engine.update(final_dir.norm(), dt)


    -- Manage weapons
    if love.keyboard.isScancodeDown("2") then
        ship.weapon.set_type(BIG_SPACE_GUN)
    elseif love.keyboard.isScancodeDown("1") then
        ship.weapon.set_type(AUTO_CANNON)
    end
    -- shoot weapon
    if love.mouse.isDown(1) then
        ship.weapon.base_sprite.play_sprite = true
    end
    ship.weapon.update(dt)
end

ship.draw = function()
    ship.base_sprite.draw(ship.pos, ship.rad + ship.image_rad_offset)
    ship.engine.draw(ship.pos, ship.rad + ship.image_rad_offset)
    ship.weapon.draw(ship.pos, ship.rad + ship.image_rad_offset)
end

return ship