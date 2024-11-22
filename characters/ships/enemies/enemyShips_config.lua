NAIRAN_FIGHTER = "nairan_figther"
NAIRAN_BATTLECRUISER = "NAIRAN_BATTLECRUISER"

local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = ENGINES.nairan_fighter,
    weapon = WEAPONS.nairan.fighter,
    health = 5,
    hitbox_radius = 10,
    base_speed = 75,
    lerp_speed = 10,
    detection_range = 1000,
    shooting_range = 500,
    harass_range = 300,
    flee_range = 150,
    avoid_ship_range = 30,
    fire_delay_seconds = 2,
    experience = 50,

}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = ENGINES.nairan_battlecruiser,
    weapon = WEAPONS.nairan.battlecruiser,
    health = 15,
    hitbox_radius = 27,
    base_speed = 50,
    lerp_speed = 5,
    detection_range = 1500,
    shooting_range = 1000,
    harass_range = 500,
    flee_range = 200,
    avoid_ship_range = 100,
    fire_delay_seconds = 3,
    experience = 100
}

return enemy_ships_params