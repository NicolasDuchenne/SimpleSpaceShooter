
local projectiles_params = require("characters.components.projectiles_config")

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

Projectiles = {}
Projectiles.update = function(dt)
    for i=#Projectiles, 1, -1 do
        Projectiles[i].update(dt)
        if Projectiles[i].time_elapsed > Projectiles[i].life_span then
            table.remove(Projectiles, i)
        end
    end

end
Projectiles.draw = function()
    for i, projectile in ipairs(Projectiles) do
        projectile.draw()
    end
end

function newProjectile(type, pos, rad, speed)
    local projectile = {}
    projectile.pos = pos
    projectile.rad = rad
    projectile.dir = newVector2FromRad(rad)
    projectile.speed = speed 
    projectile.sprite = create_projectile_sprite(projectiles_params[type])
    projectile.scale = projectiles_params[type].scale
    projectile.life_span = 5
    projectile.time_elapsed = 0
    
    projectile.update = function(dt)
        projectile.sprite.update(dt)
        projectile.pos = projectile.pos + projectile.dir * projectile.speed * dt
        projectile.time_elapsed = projectile.time_elapsed + dt

    end

    projectile.draw = function()
        projectile.sprite.draw(projectile.pos, projectile.rad + IMG_RAD_OFFSET, projectile.scale)
    end
    table.insert(Projectiles, projectile)
end