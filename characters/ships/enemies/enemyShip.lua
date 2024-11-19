NAIRAN_FIGHTER = "nairan_figther"
NAIRAN_BATTLECRUISER = "NAIRAN_BATTLECRUISER"

local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = ENGINES.nairan_fighter,
    weapon = WEAPONS.nairan_fighter
}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = ENGINES.nairan_battlecruiser,
    weapon = WEAPONS.nairan_battlecruiser
}

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
    
    ship.update = function(dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, PlayerShip.pos, ship.rad, ship.lerp_speed, dt)
        -- local target_rad = math.angle(ship.pos.x, ship.pos.y, PlayerShip.pos.x, PlayerShip.pos.y)
        -- ship.rad = LerpAngle(ship.rad, target_rad, ship.lerp_speed * dt)
        -- ship.moving_dir = newVector2FromRad(ship.rad)

        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        ship.engine.update(0, dt)
        ship.shoot()
        ship.weapon.update(dt, ship.pos, ship.rad)

    end

    table.insert(EnemyShips, ship)
    
end