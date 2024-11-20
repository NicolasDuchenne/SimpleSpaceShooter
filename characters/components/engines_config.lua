ENGINES = {}
ENGINES.base = "base_engine"
ENGINES.burst = "burst_engine"

ENGINES.nairan_fighter = "nairan_fighter_engine"
ENGINES.nairan_battlecruiser = "nairan_battlecruiser_engine"

local base_sprites = {}
local engine_effects_params = {}

base_sprites[ENGINES.base] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Base Engine.png")
engine_effects_params[ENGINES.base] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Base Engine - " ,
    idle_cquad = 3,
    powering_cquad = 4,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 8,
    always_powering = false
}

base_sprites[ENGINES.burst] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Burst Engine.png")
engine_effects_params[ENGINES.burst] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Burst Engine - " ,
    idle_cquad = 4,
    powering_cquad = 4,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 8,
    always_powering = false
}

base_sprites[ENGINES.nairan_battlecruiser] = nil
engine_effects_params[ENGINES.nairan_battlecruiser] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Engine Effects/PNGs/Nairan - Battlecruiser - Engine.png" ,
    idle_cquad = 8,
    powering_cquad = 8,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    fps = 8,
    always_powering = true
}


base_sprites[ENGINES.nairan_fighter] = nil
engine_effects_params[ENGINES.nairan_fighter] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Engine Effects/PNGs/Nairan - Fighter - Engine.png" ,
    idle_cquad = 8,
    powering_cquad = 8,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    fps = 8,
    always_powering = true
}

return {base=base_sprites, effects=engine_effects_params}
