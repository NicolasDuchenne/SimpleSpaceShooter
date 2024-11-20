local enemy_ships_params = require("characters.ships.enemies.enemyShips_config")
local newEnemyShipStateMachine = require("characters.ships.enemies.enemyShipStates")

EnemyShips = {}
EnemyShips.update = function(dt)
    for i=#EnemyShips, 1, -1 do
        EnemyShips[i].update(dt)
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
        enemy_ships_params[type].img,
        enemy_ships_params[type].engine,
        enemy_ships_params[type].weapon,
        pos,
        rad
    )
    ship.type = type
    ship.detection_range = enemy_ships_params[type].detection_range
    ship.shooting_range = enemy_ships_params[type].shooting_range

    local shipStateMachine = newEnemyShipStateMachine()
    
    ship.update = function(dt)
        shipStateMachine.update(ship, dt)

        ship.engine.update(0, dt)
        ship.weapon.update(dt, ship.pos, ship.rad)

    end

    table.insert(EnemyShips, ship)
    
end