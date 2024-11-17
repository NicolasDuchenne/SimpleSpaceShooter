local sceneGame = newScene("game")

local camera = require("level.camera")
local background = require("level.background")
local ship = require("characters.player.ship")


sceneGame.load = function(data)
    background.load()
end


sceneGame.update = function(dt)
    -- Here we simulate player movement (replace this with your actual player controls)
    camera.update(ship.pos.x, ship.pos.y)
    background.update(dt)
    ship.update(dt)
end

sceneGame.draw = function()
    --love.graphics.push()
    camera.move()
    background.draw(ship.pos.x, ship.pos.y)
    ship.draw()
    --love.graphics.pop()
end

sceneGame.keypressed = function(key)
    if key=="space" then
        changeScene("menu", "hello world")
    end
end



return sceneGame