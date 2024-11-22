
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
        if Projectiles[i].time_elapsed > Projectiles[i].life_span or Projectiles[i].has_hit_something == true then
            table.remove(Projectiles, i)
        end
    end

end
Projectiles.draw = function()
    for i, projectile in ipairs(Projectiles) do
        projectile.draw()
    end
end

function newProjectile(type, pos, rad, speed, group, damage)
    added_damage = added_damage or 0
    local projectile = {}
    projectile.pos = pos
    projectile.rad = rad
    projectile.dir = newVector2FromRad(rad)
    projectile.speed = speed
    projectile.sprite = create_projectile_sprite(projectiles_params[type])
    projectile.scale = projectiles_params[type].scale
    projectile.life_span = 5
    projectile.time_elapsed = 0
    projectile.hitbox_radius = projectiles_params[type].hitbox_radius
    projectile.damage = damage
    projectile.group = group
    projectile.has_hit_something = false
    if group == SHIP_GROUPS.PLAYER then
        projectile.color = {r = 0, g = 1, b = 0}
    elseif projectile.group == SHIP_GROUPS.ENEMY then
        projectile.color = {r = 1, g = 0, b = 0}
    else
        projectile.color = {r = 1, g = 1, b = 1}
    end

    local function hit_ships()
        if projectile.group == SHIP_GROUPS.PLAYER then
            -- Check if enemy is hit
            for i, enemyShip in ipairs(EnemyShips) do
                if math.vdist(projectile.pos, enemyShip.pos) < enemyShip.hitbox_radius+projectile.hitbox_radius then
                    enemyShip.hit(projectile.damage)
                    projectile.has_hit_something = true
                end
            end
        elseif projectile.group == SHIP_GROUPS.ENEMY then
            -- Check if player is hit
            if  math.vdist(projectile.pos, PlayerShip.pos) < PlayerShip.hitbox_radius+projectile.hitbox_radius then
                    PlayerShip.hit(projectile.damage)
                    projectile.has_hit_something = true
            end
        end
    end
    
    projectile.update = function(dt)
        projectile.sprite.update(dt)
        projectile.pos = projectile.pos + projectile.dir * projectile.speed * dt
        projectile.time_elapsed = projectile.time_elapsed + dt
        hit_ships()
    end
    local function draw_hitbox()
        love.graphics.circle("line", projectile.pos.x, projectile.pos.y, projectile.hitbox_radius)
    end

    projectile.draw = function()
        love.graphics.setColor(projectile.color.r, projectile.color.g, projectile.color.b)
        projectile.sprite.draw(projectile.pos, projectile.rad + IMG_RAD_OFFSET, projectile.scale)
        draw_hitbox()
        love.graphics.setColor(1, 1, 1)
    end
    table.insert(Projectiles, projectile)
end