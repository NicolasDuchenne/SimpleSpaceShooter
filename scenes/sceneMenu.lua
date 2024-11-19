local sceneMenu = newScene("menu")
local button_img = {}
local button_text = {}
local button_quad = {}

Font = love.graphics.newFont(12)  -- Choose your font size
love.graphics.setFont(Font)

sceneMenu.load = function(data)
    button_img = newImgButton(newVector2(200, 200), newSprite("assets/Void_MainShip/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png"))
    button_quad = newQuadButton(newVector2(400, 400), newQuadSprite("assets/Void_MainShip/Main Ship/Main Ship - Weapons/PNGs/Main Ship - Weapons - Auto Cannon.png", 7, 1, 48, 48))
    button_text = newTextButton(newVector2(300, 300), newVector2(100, 100), "test")
end

sceneMenu.update = function(dt)
end

sceneMenu.draw = function()
    for i, button in ipairs(Buttons) do
        button.draw()
    end
end

sceneMenu.keypressed = function(key, scancode)
    if scancode=="space" then
        changeScene("game")
    end
end

sceneMenu.moussepressed = function(x, y, button)
    for i, button in ipairs(Buttons) do
        button.isMouseIn(x, y)
    end
end


return sceneMenu