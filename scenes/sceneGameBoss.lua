local newBossShip = require("characters.ships.enemies.BossShip")
local sceneGame = newScenegame("gameBoss")


sceneGame.load_enemies = function()
    newBossShip(NAIRAN_BOSS, newVector2(ScaledScreenWidth/2, ScaledScreenHeight/2-200), 0)
end

sceneGame.update_camera = function()
    sceneGame.camera.pos = newVector2()
    MovingCamera = false
end

sceneGame.update_player_pos = function()
    PlayerShip.pos = newVector2(ScaledScreenWidth * 0.5, ScaledScreenHeight * 0.5)
end

sceneGame.keypressed = function(key, scancode)
    if scancode=="space" then
        sceneGame.saved_data = sceneGame.save_data()
        changeScene("menu", "hello world")
    end
    if scancode=="return" then
        sceneGame.save_and_change_scene("gameSurvivor")
    end
    -- Uncomment to test create upgrades
    -- if Pause_game==false and love.keyboard.isScancodeDown("t") then
    --     Pause_game = true
    --     PlayerShip.upgrades.create_weapon_choices()
    -- end
end
return sceneGame