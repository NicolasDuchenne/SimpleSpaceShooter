local enemySpawner = {}
enemySpawner.timer_min_duration  = 0.2
enemySpawner.timer_variation = 0.3
enemySpawner.enemy_min_distance = 500
enemySpawner.enemy_max_distance = 1000
enemySpawner.timer = newTimer(1)

enemySpawner.load = function()
    enemySpawner.timer.start()
end

enemySpawner.update = function(dt)
    if enemySpawner.timer.update(dt) then
        local enemy_index = math.random(1, #ENEMIES)
        local rad_spawn = math.random()*2*math.pi
        local enemy_pos = newVector2FromRad(rad_spawn) * math.random(enemySpawner.enemy_min_distance, enemySpawner.enemy_max_distance)
        print(enemy_pos)
        newEnemyShip(ENEMIES[enemy_index], PlayerShip.pos + enemy_pos)

        enemySpawner.timer.start(math.random()*enemySpawner.timer_variation+enemySpawner.timer_min_duration)
    end
end


return enemySpawner