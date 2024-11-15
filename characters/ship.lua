local ship = {}
ship.pos = newVector2(ScreenWidth/2, ScreenHeight/2)
ship.rad = 0
ship.image_rad_offset = math.pi/2
ship.speed = 100
ship.sprite = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png")

ship.update = function(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    --ship.rad = math.angle(ship.pos.x, ship.pos.y, mouseX, mouseY)
    --ship does not move in screen because the camera follows the ship so we calculate the angle like this
    ship.rad = math.angle(ScreenWidth * 0.5, ScreenHeight * 0.5, mouseX, mouseY) 

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


end

ship.draw = function()
    ship.sprite.draw(ship.pos, ship.rad + ship.image_rad_offset)
end

return ship