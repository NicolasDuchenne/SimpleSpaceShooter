require("characters.ships.player.experience")
require("characters.ships.player.upgrades")
require("characters.ships.player.inventory")
local health = 100
local hitbox_radius = 6
local base_speed = 200
local lerp_speed = 5

function newPlayerShip()
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
    ship.boost_activated = true
    
    ship.life_bar_size = newVector2(160,30)



    local function move(dt)
        local mouseX, mouseY = love.mouse.getPosition()
        --ship does not move in screen because the camera follows the ship so we calculate the angle like this
        local dir = nil
        local look_at_pos = nil
        if MovingCamera == true then
            look_at_pos = newVector2(ScaledScreenWidth * 0.5 * Scale, ScaledScreenHeight * 0.5 * Scale)
        else
            look_at_pos = ship.pos
        end
        ship.rad, dir = SmoothLookAt(
            look_at_pos,
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

        ship.constrain_ship_pos()
        
    end

    local shoot= function(dt)
        -- shoot weapon
        if love.mouse.isDown(1) then
            ship.weapon.shoot()
        end
        ship.weapon.update(dt, ship.pos, ship.rad)
    end

    ship.load = function()
        ship.experience = newExperience()
        ship.upgrades = newUpgrades()
        ship.inventory = newInventory()
        --ship.inventory.add_weapon(WEAPONS.player.auto_cannon)
        --ship.weapon = ship.inventory.weapons[1]
    end

    local function update_engines(dt)
        if love.keyboard.isScancodeDown("lshift") then
            ship.engine.change_type(ENGINES.burst)
            ship.is_boosting = true
        else
            ship.engine.change_type(ENGINES.base)
            ship.is_boosting = false
        end
        ship.engine.update(ship.moving_dir.norm(), dt)
    end

    local function update_weapons()
        for i, weapon in ipairs(ship.inventory.weapons) do
            if love.keyboard.isScancodeDown(tostring(i)) then
                ship.switch_weapon(i)
            end
        end
    end

    ship.update = function(dt)
        ship.experience.update(dt)
        move(dt)
        update_engines(dt)
        update_weapons()
        shoot(dt)
        ship.update_invincibility_timer(dt)
        ship.boost(dt)
    end
    

    ship.switch_weapon = function(key)
        ship.weapon = ship.inventory.weapons[key]
        ship.weapon.reset()
    end

    ship.draw_health = function()
        local x_pos = ScreenWidth*0.5-ship.life_bar_size.x*0.5
        local y_pos =  ScreenHeight - ship.life_bar_size.y
        local text = tostring(ship.health).."/"..tostring(ship.max_health)
        local textWidth = Font:getWidth(text)
        local textHeight = Font:getHeight(text)
        local text_x_pos = ScreenWidth*0.5 - textWidth * 0.5
        local text_y_pos = ScreenHeight - textHeight - 5

        love.graphics.push()
        love.graphics.origin()
        love.graphics.setColor(1,0,0,0.6)
        love.graphics.rectangle("line", x_pos, y_pos, ship.life_bar_size.x, ship.life_bar_size.y)
        love.graphics.rectangle("fill", x_pos, y_pos, ship.life_bar_size.x*(ship.health/ship.max_health), ship.life_bar_size.y)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(text, text_x_pos, text_y_pos)
        love.graphics.pop()
    end




    return ship
end