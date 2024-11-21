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
    ship.base_harass_range = enemy_ships_params[type].harass_range
    ship.harass_range = ship.base_harass_range
    ship.base_flee_range = enemy_ships_params[type].flee_range
    ship.flee_range = ship.base_flee_range
    ship.avoid_ship_range = enemy_ships_params[type].avoid_ship_range
    ship.fire_delay_seconds = enemy_ships_params[type].fire_delay_seconds
    ship.experience = enemy_ships_params[type].experience

    ship.stateMachine = newEnemyShipStateMachine(ship)

    ship.die = function()
        ship.is_dead = true
        PlayerShip.experience.gain(ship.experience)
    end
    
    ship.update = function(dt)
        ship.stateMachine.update(dt)

        ship.update_hit_timer(dt)

        ship.engine.update(0, dt)
        ship.weapon.update(dt, ship.pos, ship.rad)

    end

    table.insert(EnemyShips, ship)
    
end