local enemy_ships_params = require("characters.ships.enemies.enemyShips_config")
local newEnemyShipStateMachine = require("characters.ships.enemies.enemyShipStates")

EnemyShips = {}
EnemyShips.update = function(dt)
    for i=#EnemyShips, 1, -1 do
        EnemyShips[i].update(dt)
        if EnemyShips[i].is_dead == true then
            table.remove(EnemyShips, i)
        end
    end
end

EnemyShips.draw = function(dt)
    for i, enemyShip in ipairs(EnemyShips) do
        enemyShip.draw()
    end
end

EnemyShips.unload = function()
    for i=#EnemyShips, 1, -1 do
        table.remove(EnemyShips, i)
    end
end



function newEnemyShip(type, pos, rad)
    local ship = newShip(
        SHIP_GROUPS.ENEMY,
        enemy_ships_params[type].img,
        enemy_ships_params[type].engine,
        enemy_ships_params[type].weapon,
        enemy_ships_params[type].health,
        enemy_ships_params[type].hitbox_radius,
        enemy_ships_params[type].base_speed,
        enemy_ships_params[type].lerp_speed,
        pos,
        rad
    )
    ship.type = type
    ship.detection_range = enemy_ships_params[type].detection_range
    ship.shooting_range = enemy_ships_params[type].shooting_range
    ship.avoid_ship_range = enemy_ships_params[type].avoid_ship_range

    local shipStateMachine = newEnemyShipStateMachine()
    
    ship.update = function(dt)
        shipStateMachine.update(ship, dt)

        ship.update_hit_timer(dt)

        ship.engine.update(0, dt)
        ship.weapon.update(dt, ship.pos, ship.rad)

    end

    table.insert(EnemyShips, ship)
    
end