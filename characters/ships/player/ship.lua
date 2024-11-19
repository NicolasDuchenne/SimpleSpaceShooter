

local ship = newShip("assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png", BASE_ENGINE, AUTO_CANNON)


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

local shoot= function(dt)
    -- shoot weapon
    if love.mouse.isDown(1) then
        ship.weapon.shoot()
    end
    ship.weapon.update(dt, ship.pos, ship.rad)
end

ship.update = function(dt)
    move(dt)
    -- Manage engines
    if love.keyboard.isScancodeDown("lshift") then
        ship.engine.change_type(BURST_ENGINE)
        ship.speed = ship.base_speed * 2
    else
        ship.engine.change_type(BASE_ENGINE)
        ship.speed = ship.base_speed
    end
    ship.engine.update(ship.moving_dir.norm(), dt)


    -- Manage weapons
    if love.keyboard.isScancodeDown("1") then
        ship.weapon = newWeapon(AUTO_CANNON)
    elseif love.keyboard.isScancodeDown("2") then
        ship.weapon = newWeapon(BIG_SPACE_GUN)
    elseif love.keyboard.isScancodeDown("3") then
        ship.weapon = newWeapon(ROCKETS)
    elseif love.keyboard.isScancodeDown("4") then
        ship.weapon = newWeapon(ZAPPER)
    end
    shoot(dt)
end



return ship