WEAPONS = {}
WEAPONS.player = {}
WEAPONS.player.auto_cannon = "auto_cannon"
WEAPONS.player.big_space_gun = "big_space_gun"
WEAPONS.player.rockets = "rockets"
WEAPONS.player.zapper = "zapper"
WEAPONS.player.number = 4

WEAPONS.nairan = {}
WEAPONS.nairan.fighter = "nairan_fighter_weapon"
WEAPONS.nairan.battlecruiser = "nairan_battlecruiser_weapon"
WEAPONS.nairan.torpedo = "nairan_torpedo_weapon"
WEAPONS.nairan.boss = {}
WEAPONS.nairan.boss.dreadnought_space_gun = "nairan_dreadnought_weapon_1"
WEAPONS.nairan.boss.dreadnought_rockets = "nairan_dreadnought_weapon_2"

local weapon_sprite_params = {}
weapon_sprite_params[WEAPONS.player.auto_cannon] = {
    img ="assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Auto Cannon.png",
    cquad = 7,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    shots_per_sec = 3,
    bullet_type = PROJECTILES.auto_cannon,
    bullet_base_speed = 500,
    bullet_base_damage = 10,
    shooting_frames = {
        {
            frame = 2,
            offset = newVector2(10,0)
        },
        {
            frame = 3,
            offset = newVector2(-10,0)
        }
    },
    sound = "assets/sounds/weapon/076415_light-machine-gun-m249-39827.mp3"
}

weapon_sprite_params[WEAPONS.player.big_space_gun] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Big Space Gun.png",
    cquad = 12,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    shots_per_sec = 2,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 400,
    bullet_base_damage = 30,
    shooting_frames = {
        {
            frame = 7,
            offset = newVector2(0,-20)
        }
    },
    sound = "assets/sounds/weapon/mixkit-laser-cannon-shot-1678.wav"
}

weapon_sprite_params[WEAPONS.player.rockets] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Rockets.png",
    cquad = 17,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    shots_per_sec = 1,
    bullet_type = PROJECTILES.rockets,
    bullet_base_speed = 500,
    bullet_base_damage = 10,
    shooting_frames = {
        {
            frame = 3,
            offset = newVector2(-5,0)
        },
        {
            frame = 5,
            offset = newVector2(5,0)
        },
        {
            frame = 7,
            offset = newVector2(-10,5)
        },
        {
            frame = 9,
            offset = newVector2(10,5)
        },
        {
            frame = 11,
            offset = newVector2(-15,10)
        },
        {
            frame = 13,
            offset = newVector2(15,10)
        },
        
    },
    sound = "assets/sounds/weapon/laserrocket-5984.mp3"
}

weapon_sprite_params[WEAPONS.player.zapper] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Zapper.png",
    cquad = 14,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    shots_per_sec = 2,
    bullet_type = PROJECTILES.zapper,
    bullet_base_speed = 400,
    bullet_base_damage = 20,
    shooting_frames = {
        {
            frame = 5,
            offset = newVector2(8,-20)
        },
        {
            frame = 5,
            offset = newVector2(-8,-20)
        },
    },
    sound = "assets/sounds/weapon/snare-space-shot-80932.mp3"
}

weapon_sprite_params[WEAPONS.nairan.fighter] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Fighter - Weapons.png",
    cquad = 28,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    shots_per_sec = 0.5,
    bullet_type = PROJECTILES.rockets,
    bullet_base_speed = 400,
    bullet_base_damage = 10,
    shooting_frames = {
        {
            frame = 5,
            offset = newVector2(-5,0)
        },
        {
            frame = 9,
            offset = newVector2(5,0)
        },
        {
            frame = 13,
            offset = newVector2(-10,5)
        },
        {
            frame = 17,
            offset = newVector2(10,5)
        },
        {
            frame = 21,
            offset = newVector2(-15,10)
        },
        {
            frame = 25,
            offset = newVector2(15,10)
        },
        
    }
}

weapon_sprite_params[WEAPONS.nairan.battlecruiser] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Battlecruiser - Weapons.png",
    cquad = 9,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    shots_per_sec = 3,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 300,
    bullet_base_damage = 20,
    shooting_frames = {
        {
            frame = 2,
            offset = newVector2(0,-20)
        },
        {
            frame = 5,
            offset = newVector2(0,-20)
        },
        {
            frame = 8,
            offset = newVector2(0,-20)
        }
    }
}

weapon_sprite_params[WEAPONS.nairan.torpedo] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Torpedo Ship - Weapons.png",
    cquad = 12,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    shots_per_sec = 2,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 300,
    bullet_base_damage = 20,
    shooting_frames = {
    }
}

weapon_sprite_params[WEAPONS.nairan.boss.dreadnought_space_gun] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Dreadnought - Weapons.png",
    cquad = 34,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    shots_per_sec = 1.2,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 300,
    bullet_base_damage = 20,
    shooting_frames = {
        {
            frame = 2,
            offset = newVector2(0,-20)
        },
        {
            frame = 5,
            offset = newVector2(0,-20)
        },
        {
            frame = 8,
            offset = newVector2(0,-20)
        },
        {
            frame = 11,
            offset = newVector2(0,-20)
        },
        {
            frame = 14,
            offset = newVector2(0,-20)
        },
        {
            frame = 17,
            offset = newVector2(0,-20)
        }
    }
}

weapon_sprite_params[WEAPONS.nairan.boss.dreadnought_rockets] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Dreadnought - Weapons.png",
    cquad = 34,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    shots_per_sec = 1,
    bullet_type = PROJECTILES.rockets,
    bullet_base_speed = 300,
    bullet_base_damage = 20,
    shooting_frames = {
        {
            frame = 2,
            offset = newVector2(0,-20)
        },
        {
            frame = 5,
            offset = newVector2(0,-20)
        },
        {
            frame = 8,
            offset = newVector2(0,-20)
        },
        {
            frame = 11,
            offset = newVector2(0,-20)
        },
        {
            frame = 14,
            offset = newVector2(0,-20)
        },
        {
            frame = 17,
            offset = newVector2(0,-20)
        }
    }
}

return weapon_sprite_params