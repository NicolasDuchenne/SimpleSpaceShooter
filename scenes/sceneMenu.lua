local sceneMenu = newScene("menu")

sceneMenu.load = function(data)
    print(data)
end

sceneMenu.update = function(dt)
end

sceneMenu.draw = function()
    love.graphics.rectangle("fill", 200, 200, 100, 100)
end

sceneMenu.keypressed = function(key, scancode)
    if scancode=="space" then
        changeScene("game")
    end
end


return sceneMenu