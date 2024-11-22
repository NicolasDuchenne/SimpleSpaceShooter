 NAIRAN_FIGHTER = "nairan_figther"
 NAIRAN_BATTLECRUISER = "nairan_battlecruiser"
 NAIRAN_TORPEDO = "nairan_torpedo"

ENEMIES = {}
table.insert(ENEMIES, {name = NAIRAN_FIGHTER, rareness = 5})
table.insert(ENEMIES, {name = NAIRAN_BATTLECRUISER, rareness = 1})
table.insert(ENEMIES, {name = NAIRAN_TORPEDO, rareness = 10})

ENEMIES_WITH_RARENESS = {}
for i, enemy in ipairs(ENEMIES) do
    for j=1, enemy.rareness do
        table.insert(ENEMIES_WITH_RARENESS, enemy.name)
    end
end



local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = ENGINES.nairan.fighter,
    weapon = WEAPONS.nairan.fighter,
    health = 30,
    hitbox_radius = 10,
    base_speed = 75,
    lerp_speed = 10,
    detection_range = 10000,
    shooting_range = 500,
    harass_range = 300,
    flee_range = 150,
    avoid_ship_range = 30,
    fire_delay_seconds = 2,
    experience = 50,

}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = ENGINES.nairan.battlecruiser,
    weapon = WEAPONS.nairan.battlecruiser,
    health = 80,
    hitbox_radius = 27,
    base_speed = 50,
    lerp_speed = 5,
    detection_range = 15000,
    shooting_range = 1000,
    harass_range = 500,
    flee_range = 200,
    avoid_ship_range = 100,
    fire_delay_seconds = 3,
    experience = 100
}


enemy_ships_params[NAIRAN_TORPEDO] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Torpedo Ship - Base.png",
    engine = ENGINES.nairan.torpedo,
    weapon = WEAPONS.nairan.torpedo,
    health = 20,
    hitbox_radius = 10,
    base_speed = 100,
    lerp_speed = 10,
    detection_range = 15000,
    shooting_range = 0,
    harass_range = 0,
    flee_range = 0,
    avoid_ship_range = 0,
    fire_delay_seconds = 1000000,
    experience = 50,
    self_destruct = true
}

return enemy_ships_params