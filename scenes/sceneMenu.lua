local sceneMenu = newScene("menu")
local menu = require("ui.menu_ui")
local background = require("level.background")

sceneMenu.load = function()
    background.load()
    menu.create_buttons()
end

sceneMenu.unload = function()
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