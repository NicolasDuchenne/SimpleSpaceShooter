local sceneGame = newScenegame("gameMovingCamera")
sceneGame.update_camera = function()
    MovingCamera = true
end

sceneGame.keypressed = function(key, scancode)
    if Pause_game == false then
        if scancode=="space" then
            changeScene("menu", "hello world")
        end
        if scancode=="return" then
            sceneGame.save_and_change_scene("gameStaticCamera")
        end
    end
    -- Uncomment to test create upgrades
    -- if Pause_game==false and love.keyboard.isScancodeDown("t") then
    --     Pause_game = true
    --     PlayerShip.upgrades.create_weapon_choices()
    -- end
end
return sceneGame