NAIRAN_FIGHTER = "nairan_figther"
NAIRAN_BATTLECRUISER = "NAIRAN_BATTLECRUISER"

local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = ENGINES.nairan_fighter,
    weapon = WEAPONS.nairan_fighter,
    health = 10,
    hitbox_radius = 10,
    base_speed = 150,
    lerp_speed = 10,
    detection_range = 1000,
    shooting_range = 400,
    avoid_ship_range = 30,

}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = ENGINES.nairan_battlecruiser,
    weapon = WEAPONS.nairan_battlecruiser,
    health = 30,
    hitbox_radius = 27,
    base_speed = 100,
    lerp_speed = 2,
    detection_range = 1500,
    shooting_range = 1000,
    avoid_ship_range = 100,
}

return enemy_ships_params