local camera = {}
camera.x = 0
camera.y = 0


camera.update = function(x, y)
    -- Center camera on the target, adjusting to screen size if needed
    camera.x = x - ScreenWidth /2
    camera.y = y - ScreenHeight / 2
end

camera.move = function()
    love.graphics.translate(-camera.x , -camera.y)
end

return camera