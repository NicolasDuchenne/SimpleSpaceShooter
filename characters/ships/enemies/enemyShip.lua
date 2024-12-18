local enemy_ships_params = require("characters.ships.enemies.enemyShips_config")
local newEnemyShipStateMachine = require("characters.ships.enemies.enemyShipStates")

EnemyShips = {}
EnemyShips.total_exp = 0

EnemyShips.remove_ship = function(key)
    EnemyShips.total_exp = EnemyShips.total_exp - EnemyShips[key].experience
    table.remove(EnemyShips, key)
end


EnemyShips.update = function(dt)
    for i=#EnemyShips, 1, -1 do
        EnemyShips[i].update(dt)
        if EnemyShips[i].death_animation_finished == true then
            EnemyShips.remove_ship(i)
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
        EnemyShips.remove_ship(i)
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
        rad,
        enemy_ships_params[type].destruction_animation
    )
    ship.type = type
    ship.detection_range = enemy_ships_params[type].detection_range
    ship.shooting_range = enemy_ships_params[type].shooting_range
    ship.base_harass_range = enemy_ships_params[type].harass_range
    ship.harass_range = ship.base_harass_range
    ship.avoid_ship_range = enemy_ships_params[type].avoid_ship_range
    ship.fire_delay_seconds = enemy_ships_params[type].fire_delay_seconds
    ship.experience = enemy_ships_params[type].experience
    
    ship.self_destruct = enemy_ships_params[type].self_destruct or false
    ship.stateMachine = newEnemyShipStateMachine(ship)

    ship.health_per_level = enemy_ships_params[type].health_per_level
    ship.damage_per_level = enemy_ships_params[type].damage_per_level

    

    ship.die = function()
        ship.common_death_process()
        PlayerShip.experience.gain(ship.experience)
    end

    ship.hit_player = function()
        if ship.self_destruct == true then
            if  math.vdist(ship.pos, PlayerShip.pos) < PlayerShip.hitbox_radius+ship.hitbox_radius then
                PlayerShip.hit(ship.weapon.bullet_damage)
                ship.hit(ship.health)
            end
        end
    end

    ship.draw_state = function()
        
        love.graphics.print(tostring(ship.stateMachine.state.name), ship.pos.x-10, ship.pos.y-50)
    
    end
    
    ship.update = function(dt)
        if ship.is_dead == false then
            ship.stateMachine.update(dt)
            ship.update_invincibility_timer(dt)
            ship.update_blink_timer(dt)
            ship.engine.update(0, dt)
            ship.weapon.update(dt, ship.pos, ship.rad)
            ship.hit_player()
        else
            ship.update_death_animation(dt)
        end

    end

    table.insert(EnemyShips, ship)
    EnemyShips.total_exp = EnemyShips.total_exp + ship.experience

    return ship
    
end