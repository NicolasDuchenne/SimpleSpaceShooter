AUTO_CANNON_PROJECTILE = "auto_cannon_projectile"
BIG_SPACE_GUN_PROJECTILE = "big_space_gun_projectile"
ROCKETS_PROJECTILE = "rockets_projectile"
ZAPPER_PROJECTILE = "zapper_projectile"

Projectiles = {}


local function create_projectile_sprite(params)
    return newQuadSprite(
        params.img,
        params.cquad,
        params.lquad,
        params.wquad,
        params.hquad,
        params.fps
    )
end

local projectiles_params = {}
projectiles_params[AUTO_CANNON_PROJECTILE]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Auto cannon bullet.png",
    cquad = 4,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(0.5,0.5)
}

projectiles_params[BIG_SPACE_GUN_PROJECTILE]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Big Space Gun.png",
    cquad = 10,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(1,1)
}

projectiles_params[ROCKETS_PROJECTILE]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Rocket.png",
    cquad = 3,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(1,1)
}
projectiles_params[ZAPPER_PROJECTILE]= {
    img = "assets/Void_MainShip/Main Ship/Main ship - Projectiles/PNGs/Main ship weapon - Projectile - Zapper.png",
    cquad = 8,
    lquad = 1,
    wquad = 32,
    hquad = 32,
    fps = 8,
    scale = newVector2(0.8,0.8)
}

for type, params in pairs(projectiles_params) do
    params.sprite = create_projectile_sprite(params)
end


function newProjectile(type, pos, rad, speed)
    local projectile = {}
    projectile.pos = pos
    projectile.rad = rad
    projectile.dir = newVector2FromRad(rad)
    projectile.speed = speed 
    projectile.sprite = projectiles_params[type].sprite
    projectile.scale = projectiles_params[type].scale
    
    projectile.update = function(dt)
        projectile.sprite.update(dt)
        projectile.pos = projectile.pos + projectile.dir * projectile.speed * dt
    end

    projectile.draw = function()
        projectile.sprite.draw(projectile.pos, projectile.rad + IMG_RAD_OFFSET, projectile.scale)
    end
    table.insert(Projectiles, projectile)
end