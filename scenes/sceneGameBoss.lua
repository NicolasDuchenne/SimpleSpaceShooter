local newBossShip = require("characters.ships.enemies.bossShip")
local sceneGame = newScenegame("gameBoss")
local newSurvivorTriger = require("level.survivorTrigger")

sceneGame.music_name = "assets/sounds/ambiance/DavidKBD - Cosmic Pack 05 - Stellar Confrontation-full.ogg"


sceneGame.load_enemies = function()
    newBossShip(NAIRAN_BOSS, newVector2(ScaledScreenWidth/2, ScaledScreenHeight/6), 0)
end


function Create_survivor_vortex()
    if sceneGame.vortex_created == false then
        sceneGame.vortex_created = true
        local trigger = newSurvivorTriger()
        trigger.set_callback(sceneGame.change_to_survivor_scene)
    end
end

sceneGame.update_camera = function()
    sceneGame.camera.pos = newVector2()
    MovingCamera = false
end

sceneGame.update_player_pos = function()
    PlayerShip.pos = newVector2(ScaledScreenWidth * 0.5, ScaledScreenHeight * 0.75)
end

sceneGame.keypressed = function(key, scancode)
    sceneGame.pause_music(scancode)
    sceneGame.pause_game(scancode)
    if scancode=="space" then
        sceneGame.saved_data = sceneGame.save_data()
        changeScene("menu", "hello world")
    end
    if scancode=="return" then
        sceneGame.save_and_change_scene("gameSurvivor")
    end
end
return sceneGame