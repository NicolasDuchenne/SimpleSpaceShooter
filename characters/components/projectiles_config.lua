PROJECTILES = {}

PROJECTILES.auto_cannon = "auto_cannon_projectile"
PROJECTILES.space_gun = "big_space_gun_projectile"
PROJECTILES.rockets = "rockets_projectile"
PROJECTILES.zapper = "zapper_projectile"

PROJECTILES.nairan_bolt = "nairan_bolt_projectile"

PROJECTILES_STYLES = {}
PROJECTILES_STYLES.normal = "normal_style"
PROJECTILES_STYLES.rebound = "rebound_style"
PROJECTILES_STYLES.goes_through = "goes_through_style"
PROJECTILES_STYLES.heat_seaking = "heat_seaking_style"



local projectiles_params = {}
projectiles_params[PROJECTILES.auto_cannon]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Auto cannon bullet.png",
    cquad = 4,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(1,1),
    hitbox_radius = 3,
    style = PROJECTILES_STYLES.normal
}

projectiles_params[PROJECTILES.space_gun]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Big Space Gun.png",
    cquad = 10,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(1.5,1.5),
    hitbox_radius = 8,
    style = PROJECTILES_STYLES.goes_through

    
}

projectiles_params[PROJECTILES.rockets]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Rocket.png",
    cquad = 3,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(2,2),
    hitbox_radius = 3,
    style = PROJECTILES_STYLES.heat_seaking,
    base_lerp_speed = 3,
    detection_range = 500,
    lerp_acceleration_range = 200
}
projectiles_params[PROJECTILES.zapper]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Zapper.png",
    cquad = 8,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(1,1),
    hitbox_radius = 3,
    style = PROJECTILES_STYLES.rebound
}

projectiles_params[PROJECTILES.nairan_bolt]= {
    img = "assets/Void_EnemyFleet_2/Nairan/Weapon Effects - Projectiles/PNGs/Nairan - Bolt.png",
    cquad = 5,
    lquad = 1,
    wquad = 9,
    hquad = 9,
    fps = 8,
    scale = newVector2(2,2),
    hitbox_radius = 3,
    style=PROJECTILES_STYLES.normal
}

return projectiles_params