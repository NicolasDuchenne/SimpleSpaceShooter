
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
        if Projectiles[i].life_timer.update(dt) or Projectiles[i].has_hit_something == true then
            table.remove(Projectiles, i)
        end
    end

end

Projectiles.unload = function()
    for i=#Projectiles, 1, -1 do
        table.remove(Projectiles, i)
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
    projectile.style = projectiles_params[type].style
    projectile.can_be_shot_down = projectiles_params[type].can_be_shot_down
    projectile.life_timer = newTimer(projectiles_params[type].life_timer or 5)
    projectile.life_timer.start()
    projectile.hitbox_radius = projectiles_params[type].hitbox_radius * projectile.scale.x
    projectile.damage = damage
    projectile.group = group
    projectile.has_hit_something = false
    projectile.can_hit = true
    projectile.hit_timer = newTimer(0.2)

    projectile.closest_enemy = nil

    
    if group == SHIP_GROUPS.PLAYER then
        projectile.color = newColor(0, 255, 0)
    elseif projectile.group == SHIP_GROUPS.ENEMY then
        projectile.color = newColor(255, 0, 0)
    else
        projectile.color = newColor(255, 255, 255)
    end

    local function get_closest_enemy()
        projectile.closest_enemy = nil
        local closest_dist = projectile.detection_range
        if projectile.group == SHIP_GROUPS.PLAYER then
            -- Check if enemy is hit
            for i, enemyShip in ipairs(EnemyShips) do
                local enemy_dist = math.vdist(projectile.pos, enemyShip.pos) 
                if enemy_dist < closest_dist then
                    projectile.closest_enemy = enemyShip
                    closest_dist = enemy_dist
                end
            end
        elseif projectile.group == SHIP_GROUPS.ENEMY then
            projectile.closest_enemy = PlayerShip
        end
    end

    projectile.load_heat_seaking = function()
        projectile.base_lerp_speed = projectiles_params[type].base_lerp_speed
        projectile.lerp_speed = projectile.base_lerp_speed
        projectile.detection_range = projectiles_params[type].detection_range
        projectile.lerp_acceleration_range = projectiles_params[type].lerp_acceleration_range
        get_closest_enemy()
    end
    
    if projectile.style == PROJECTILES_STYLES.heat_seaking then
        projectile.load_heat_seaking()
    end


    projectile.process_hit = function()
        projectile.can_hit = false
        projectile.hit_timer.start()
        if projectile.style == PROJECTILES_STYLES.goes_through then
            
        elseif projectile.style == PROJECTILES_STYLES.rebound then
            local rebound_rad = 1/4*math.pi
            projectile.rad = projectile.rad + rebound_rad
            projectile.dir = projectile.dir.rotate(rebound_rad)
        else
            projectile.has_hit_something = true
        end
    end

    local function hit_ships()
        if projectile.can_hit == true then
            if projectile.group == SHIP_GROUPS.PLAYER then
                -- Check if enemy is hit
                for i, enemyShip in ipairs(EnemyShips) do
                    if math.vdist(projectile.pos, enemyShip.pos) < enemyShip.hitbox_radius+projectile.hitbox_radius then
                        enemyShip.hit(projectile.damage)
                        projectile.process_hit()
                    end
                end
            elseif projectile.group == SHIP_GROUPS.ENEMY then
                -- Check if player is hit
                if  math.vdist(projectile.pos, PlayerShip.pos) < PlayerShip.hitbox_radius+projectile.hitbox_radius then
                        PlayerShip.hit(projectile.damage)
                        projectile.process_hit()
                end
            end
        end
    end

    local function hit_projectiles()
        if projectile.group == SHIP_GROUPS.PLAYER then
            for i, tmp_projectile in ipairs(Projectiles) do
                if tmp_projectile.group == SHIP_GROUPS.ENEMY and tmp_projectile.can_be_shot_down == true  then
                    if math.vdist(projectile.pos, tmp_projectile.pos) < tmp_projectile.hitbox_radius+projectile.hitbox_radius then
                        projectile.process_hit()
                        tmp_projectile.process_hit()
                    end
                end
            end
        end
    end

    projectile.update_hit_timer = function(dt)
        if projectile.hit_timer.update(dt) then
            projectile.can_hit = true
        end
    end
    
    projectile.update = function(dt)
        if projectile.style == PROJECTILES_STYLES.heat_seaking and projectile.closest_enemy and projectile.closest_enemy.is_dead == false then
            projectile.rad, projectile.dir = SmoothLookAt(projectile.pos, projectile.closest_enemy.pos, projectile.rad, projectile.lerp_speed, dt)
            if math.vdist(projectile.pos, projectile.closest_enemy.pos) < projectile.lerp_acceleration_range then
                projectile.lerp_speed = projectile.base_lerp_speed * projectile.speed/100
                projectile.lerp_acceleration_range = projectile.lerp_acceleration_range + 10
            end
        end
        projectile.update_hit_timer(dt)
        projectile.sprite.update(dt)
        projectile.pos = projectile.pos + projectile.dir * projectile.speed * dt
        hit_ships()
        hit_projectiles()
    end
    local function draw_hitbox()
        love.graphics.circle("line", projectile.pos.x, projectile.pos.y, projectile.hitbox_radius)
    end

    projectile.draw = function()
        love.graphics.setColor(projectile.color.r, projectile.color.g, projectile.color.b)
        projectile.sprite.draw(projectile.pos, projectile.rad + IMG_RAD_OFFSET, projectile.scale)
        --draw_hitbox()
        love.graphics.setColor(1, 1, 1)
    end
    table.insert(Projectiles, projectile)
end