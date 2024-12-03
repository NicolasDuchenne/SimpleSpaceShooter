local enemySpawner = {}
enemySpawner.timer_min_duration  = 1
enemySpawner.timer_variation = 0.1
enemySpawner.enemy_min_distance = 500
enemySpawner.enemy_max_distance = 1000
enemySpawner.timer_duration = 1
enemySpawner.timer = newTimer(enemySpawner.timer_duration)
enemySpawner.base_max_enemies_experience = 1000
enemySpawner.max_max_enemies_experience = 10000
enemySpawner.max_enemies_experience = enemySpawner.base_max_enemies_experience

enemySpawner.load = function()
    enemySpawner.timer.start()
end

enemySpawner.update = function(dt)
    if enemySpawner.timer.update(dt) then
        -- Increase max enemies and decrease spawn interval with levels and experience
        enemySpawner.max_enemies_experience = enemySpawner.base_max_enemies_experience + enemySpawner.max_max_enemies_experience*(1-1/(PlayerShip.experience.total_exp/enemySpawner.max_max_enemies_experience+1))
        enemySpawner.timer_min_duration = math.min(1, 5/PlayerShip.experience.level)
        if  EnemyShips.total_exp < enemySpawner.max_enemies_experience then
            local enemy_index = math.random(1, #ENEMIES_WITH_RARENESS)
            local rad_spawn = math.random()*2*math.pi
            local enemy_pos = newVector2FromRad(rad_spawn) * math.random(enemySpawner.enemy_min_distance, enemySpawner.enemy_max_distance)
            local ship = newEnemyShip(ENEMIES_WITH_RARENESS[enemy_index], PlayerShip.pos + enemy_pos)
            ship.increase_max_health(ship.health_per_level * PlayerShip.experience.level-1)
        end

        enemySpawner.timer.start(math.random()*enemySpawner.timer_variation+enemySpawner.timer_min_duration)
    end
end


return enemySpawner