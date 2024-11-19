local sceneGame = newScene("game")


require("characters.ships.shipFactory")
require("characters.ships.enemies.enemyShip")

local camera = require("level.camera")
local background = require("level.background")
local ship = require("characters.ships.player.ship")




sceneGame.load = function(data)
    background.load()
    newEnemyShip(NAIRAN_FIGHTER, newVector2(100, 100))
    newEnemyShip(NAIRAN_FIGHTER, newVector2(100, 250))
    newEnemyShip(NAIRAN_BATTLECRUISER, newVector2(100, 500))
    
end


sceneGame.update = function(dt)
    -- Here we simulate player movement (replace this with your actual player controls)
    camera.update(ship.pos.x, ship.pos.y)
    background.update(dt)
    ship.update(dt)
    EnemyShips.update(dt)
    Projectiles.update(dt)
end

local function draw_game()
    love.graphics.push()
    camera.move()
    background.draw(ship.pos.x, ship.pos.y)
    EnemyShips.draw()
    Projectiles.draw()
    ship.draw()
    love.graphics.pop()
end

local function draw_ui()
    love.graphics.origin()
    Buttons.draw()
end

sceneGame.draw = function()
    draw_game()
    draw_ui()
end

sceneGame.keypressed = function(key, scancode)
    if scancode=="space" then
        changeScene("menu", "hello world")
    end
end

sceneGame.moussepressed = function(x, y, button)
end



return sceneGame