local sceneMenu = newScene("menu")
local menu = require("ui.menu_ui")
local background = require("level.background")

sceneMenu.music_name = "assets/sounds/ambiance/DavidKBD - Cosmic Pack 01 - Cosmic Journey-full.ogg"

sceneMenu.load = function()
    PlayMusic(sceneMenu.music_name)
    background.load()
    menu.create_buttons()
end

sceneMenu.unload = function()
    love.audio.stop()
    Buttons.unload()
end

sceneMenu.update = function(dt)
    background.update(dt, 0, 0)
    local mouseX, mouseY = love.mouse.getPosition()
    Buttons.update(dt, mouseX, mouseY)
    if menu.start_button.isPressed then
        changeScene("gameSurvivor", nil, true)
    end
end

sceneMenu.draw = function()
    background.draw()
    love.graphics.origin()
    Buttons.draw()
end

sceneMenu.keypressed = function(key, scancode)
end

sceneMenu.moussepressed = function(x, y, button)
    Buttons.mousepressed(button)
end


return sceneMenu