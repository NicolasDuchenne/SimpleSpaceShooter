require("characters.components.engines")
require("characters.components.weapons")

local ship = {}
ship.pos = newVector2(ScreenWidth/2, ScreenHeight/2)
ship.rad = 0
ship.moving_dir = newVector2()
ship.base_speed = 100
ship.speed = ship.base_speed
ship.lerp_speed = 5
ship.base_sprite = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png")
ship.engine = newEngine(BASE_ENGINE)
ship.weapon = newWeapon(AUTO_CANNON)

local function move(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    --ship.rad = math.angle(ship.pos.x, ship.pos.y, mouseX, mouseY)
    --ship does not move in screen because the camera follows the ship so we calculate the angle like this
    local target_rad = math.angle(ScreenWidth * 0.5 * SCALE, ScreenHeight * 0.5 * SCALE, mouseX, mouseY)
    ship.rad = LerpAngle(ship.rad, target_rad, ship.lerp_speed * dt)

    local dir = newVector2FromRad(ship.rad)

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

    ship.moving_dir = (up_dir + side_dir).normalize()
    ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
end

ship.update = function(dt)
    move(dt)

    -- Manage engines
    if love.keyboard.isScancodeDown("lshift") then
        ship.engine.set_type(BURST_ENGINE)
        ship.speed = ship.base_speed * 2
    else
        ship.engine.set_type(BASE_ENGINE)
        ship.speed = ship.base_speed
    end
    ship.engine.update(ship.moving_dir.norm(), dt)


    -- Manage weapons
    if love.keyboard.isScancodeDown("1") then
        ship.weapon.set_type(AUTO_CANNON)
    elseif love.keyboard.isScancodeDown("2") then
        ship.weapon.set_type(BIG_SPACE_GUN)
    elseif love.keyboard.isScancodeDown("3") then
        ship.weapon.set_type(ROCKETS)
    elseif love.keyboard.isScancodeDown("4") then
        ship.weapon.set_type(ZAPPER)
    end
    -- shoot weapon
    if love.mouse.isDown(1) then
        ship.weapon.shoot()
    end
    ship.weapon.update(dt, ship.pos, ship.rad)
end

ship.draw = function()
    ship.base_sprite.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
    ship.engine.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
    ship.weapon.draw(ship.pos, ship.rad + IMG_RAD_OFFSET)
end

return ship