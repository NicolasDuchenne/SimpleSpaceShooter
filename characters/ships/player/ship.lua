local health = 500
local hitbox_radius = 10
local base_speed = 200
local lerp_speed = 5

local ship = newShip(
    SHIP_GROUPS.PLAYER,
    "assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png",
    ENGINES.base,
    WEAPONS.player.auto_cannon,
    health,
    hitbox_radius,
    base_speed,
    lerp_speed
)
ship.experience = require("characters.ships.player.experience")
ship.upgrades = require("characters.ships.player.upgrades")
ship.boost_factor = 1.5


local function move(dt)
    local mouseX, mouseY = love.mouse.getPosition()
    --ship does not move in screen because the camera follows the ship so we calculate the angle like this
    local dir = nil
    ship.rad, dir = SmoothLookAt(
        newVector2(ScaledScreenWidth * 0.5 * Scale, ScaledScreenHeight * 0.5 * Scale),
        newVector2(mouseX, mouseY),
        ship.rad,
        ship.lerp_speed,
        dt
    )

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

ship.load = function()
    ship.inventory = require("characters.ships.player.inventory")
    ship.inventory.add_weapon(WEAPONS.player.auto_cannon)
    ship.weapon = ship.inventory.weapons[1]
end

ship.update = function(dt)
    ship.experience.update(dt)
    move(dt)
    -- Manage engines
    if love.keyboard.isScancodeDown("lshift") then
        ship.engine.change_type(ENGINES.burst)
        ship.speed = ship.base_speed * ship.boost_factor
    else
        ship.engine.change_type(ENGINES.base)
        ship.speed = ship.base_speed
    end
    ship.engine.update(ship.moving_dir.norm(), dt)


    for i, weapon in ipairs(ship.inventory.weapons) do
        if love.keyboard.isScancodeDown(tostring(i)) then
            ship.weapon = weapon
            ship.weapon.reset()
        end
    end

    shoot(dt)
    ship.update_hit_timer(dt)
end

ship.die = function()
    print("Player Ship Dead")
end




return ship