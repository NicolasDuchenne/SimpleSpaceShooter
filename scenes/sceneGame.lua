local sceneGame = newScene("game")

local camera = require("level.camera")
local background = require("level.background")

-- Variables for parallax layers and speed
local playerX = 0  -- Player's X position (you can adjust this for your own player logic)
local playerY = 0

sceneGame.load = function(data)
    background.load()
end


sceneGame.update = function(dt)
    -- Here we simulate player movement (replace this with your actual player controls)
    playerX = playerX + 100 * dt  -- The player moves to the right at 100 pixels per second
    playerY = playerY + 100 * dt  -- The player moves to the right at 100 pixels per second
    camera.update(playerX, playerY)
    background.update(dt)
end

sceneGame.draw = function()
    --love.graphics.push()
        
    camera.move()
    background.draw(playerX, playerY)
    -- Example target drawing (e.g., the player)
    love.graphics.circle("fill", playerX, playerY, 10) -- Target object
    --love.graphics.pop()
end

sceneGame.keypressed = function(key)
    if key=="space" then
        changeScene("menu", "hello world")
    end
end



return sceneGame