NAIRAN_FIGHTER = "nairan_figther"
NAIRAN_BATTLECRUISER = "NAIRAN_BATTLECRUISER"

local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = NAIRAN_FIGHTER_ENGINE,
    weapon = NAIRAN_FIGHTER_WEAPON
}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = NAIRAN_BATTLECRUISER_ENGINE,
    weapon = NAIRAN_BATTLECRUISER_WEAPON
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



function newEnemyShip(type, pos, rad)
    local enemyShip = newShip(
        enemy_ships_params[type].img,
        enemy_ships_params[type].engine,
        enemy_ships_params[type].weapon,
        pos,
        rad
    )

    table.insert(EnemyShips, enemyShip)
    
end