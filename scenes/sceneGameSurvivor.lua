local sceneGame = newScenegame("gameSurvivor")
local enemySpawner = require("characters.ships.enemies.enemySpawner")
local newBossTrigger = require("level.bossTrigger")


sceneGame.update_game = function(dt)
    sceneGame.update_game_without_enemies(dt)
    enemySpawner.update(dt)
end

sceneGame.load_enemies = function()

    enemySpawner.load()
end

function Create_boss_vortex()
    if sceneGame.vortex_created == false then
        sceneGame.vortex_created = true
        local offset = math.random(400,800)
        local trigger = newBossTrigger(PlayerShip.pos + offset)
        trigger.set_callback(sceneGame.change_to_boss_scene)
    end
end

sceneGame.update_camera = function()
    MovingCamera = true
end

sceneGame.keypressed = function(key, scancode)
    if Pause_game == false then
        if scancode=="space" then
            changeScene("menu", "hello world")
        end
        if scancode=="return" then
            sceneGame.save_and_change_scene("gameBoss")
        end
    end
end
return sceneGame