local sceneGame = newScene("game")


require("characters.ships.shipFactory")
require("characters.ships.enemies.enemyShip")

local camera = require("level.camera")
local background = require("level.background")
PlayerShip = require("characters.ships.player.ship")
sceneGame.saved_data = nil


sceneGame.load = function()
    
    background.load()
    if sceneGame.saved_data then
        EnemyShips = sceneGame.saved_data.EnemyShips
        Buttons = sceneGame.saved_data.Buttons
        Projectiles = sceneGame.saved_data.Projectiles
        PlayerShip = sceneGame.saved_data.PlayerShip
    else
        PlayerShip.load()
        newEnemyShip(NAIRAN_FIGHTER, newVector2(100, 100))
        newEnemyShip(NAIRAN_FIGHTER, newVector2(100, 250))
        newEnemyShip(NAIRAN_BATTLECRUISER, newVector2(100, 500))
    end
end

sceneGame.unload = function()
    Buttons.unload()
end

local function update_game(dt)
    camera.update(PlayerShip.pos.x, PlayerShip.pos.y)
    background.update(dt)
    PlayerShip.update(dt)
    EnemyShips.update(dt)
    Projectiles.update(dt)
end

local function update_ui(dt)
    Buttons.update(dt)
end


sceneGame.update = function(dt)
    update_game(dt)
    update_ui(dt)
end

local function draw_game()
    love.graphics.push()
    camera.move()
    background.draw(PlayerShip.pos.x, PlayerShip.pos.y)
    EnemyShips.draw()
    PlayerShip.draw()
    Projectiles.draw()
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

sceneGame.save_data = function()
    local data = {}
    data.PlayerShip = PlayerShip
    data.EnemyShips = EnemyShips
    data.Buttons = DeepCopy(Buttons)
    data.Projectiles = Projectiles
    return data
end

sceneGame.keypressed = function(key, scancode)
    if scancode=="space" then
        sceneGame.saved_data = sceneGame.save_data()
        changeScene("menu", "hello world")
    end
end

sceneGame.moussepressed = function(x, y, button)
end



return sceneGame