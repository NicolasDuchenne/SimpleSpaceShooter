NAIRAN_BOSS = "nairan_boss"

local boss_ship_params = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Dreadnought - Base.png",
    engine = ENGINES.nairan.dreadnought,
    weapon = WEAPONS.nairan.dreadnought,
    health = 200,
    hitbox_radius = 40,
    base_speed = 100,
    lerp_speed = 10,
    experience = 500,
    
}


local function newBossShip(type, pos, rad)
    local ship = newShip(
        SHIP_GROUPS.ENEMY,
        boss_ship_params.img,
        boss_ship_params.engine,
        boss_ship_params.weapon,
        boss_ship_params.health,
        boss_ship_params.hitbox_radius,
        boss_ship_params.base_speed,
        boss_ship_params.lerp_speed,
        pos,
        rad
    )
    ship.type = type
    ship.experience = boss_ship_params.experience

    table.insert(EnemyShips, ship)

    ship.die = function()
        ship.is_dead = true
        PlayerShip.experience.gain(ship.experience)
    end

    EnemyShips.total_exp = EnemyShips.total_exp + ship.experience
    
end

return newBossShip