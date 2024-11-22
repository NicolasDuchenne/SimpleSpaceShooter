WEAPONS = {}
WEAPONS.player = {}
WEAPONS.player.auto_cannon = "auto_cannon"
WEAPONS.player.big_space_gun = "big_space_gun"
WEAPONS.player.rockets = "rockets"
WEAPONS.player.zapper = "zapper"

WEAPONS.nairan = {}
WEAPONS.nairan.fighter = "nairan_fighter_weapon"
WEAPONS.nairan.battlecruiser = "nairan_battlecruiser_weapon"


local weapon_sprite_params = {}
weapon_sprite_params[WEAPONS.player.auto_cannon] = {
    img ="assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Auto Cannon.png",
    cquad = 7,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 24,
    bullet_type = PROJECTILES.auto_cannon,
    bullet_base_speed = 400,
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
    }
}

weapon_sprite_params[WEAPONS.player.big_space_gun] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Big Space Gun.png",
    cquad = 12,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 18,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 200,
    bullet_base_damage = 30,
    shooting_frames = {
        {
            frame = 7,
            offset = newVector2(0,-20)
        }
    }
}

weapon_sprite_params[WEAPONS.player.rockets] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Rockets.png",
    cquad = 17,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 12,
    bullet_type = PROJECTILES.rockets,
    bullet_base_speed = 300,
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
        
    }
}

weapon_sprite_params[WEAPONS.player.zapper] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Zapper.png",
    cquad = 14,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 24,
    bullet_type = PROJECTILES.zapper,
    bullet_base_speed = 300,
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
    }
}

weapon_sprite_params[WEAPONS.nairan.fighter] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapons/PNGs/Nairan - Fighter - Weapons.png",
    cquad = 28,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    fps = 12,
    bullet_type = PROJECTILES.rockets,
    bullet_base_speed = 300,
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
    fps = 24,
    bullet_type = PROJECTILES.space_gun,
    bullet_base_speed = 200,
    bullet_base_damage = 20,
    shooting_frames = {
        {
            frame = 5,
            offset = newVector2(0,-20)
        }
    }
}

return weapon_sprite_params