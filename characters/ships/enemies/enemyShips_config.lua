NAIRAN_FIGHTER = "nairan_figther"
NAIRAN_BATTLECRUISER = "NAIRAN_BATTLECRUISER"

local enemy_ships_params = {}
enemy_ships_params[NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Fighter - Base.png",
    engine = ENGINES.nairan_fighter,
    weapon = WEAPONS.nairan_fighter,
    detection_range = 500,
    shooting_range = 200,
    health = 10,
    hitbox_radius = 10,
    speed = 200,
    lerp_speed = 10,

}

enemy_ships_params[NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Battlecruiser - Base.png",
    engine = ENGINES.nairan_battlecruiser,
    weapon = WEAPONS.nairan_battlecruiser,
    detection_range = 1000,
    shooting_range = 500,
    health = 30,
    hitbox_radius = 27,
    speed = 100,
    lerp_speed = 2,
}

return enemy_ships_params