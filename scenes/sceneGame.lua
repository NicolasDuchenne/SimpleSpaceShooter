local sceneGame = newScene("game")


require("characters.ships.shipFactory")
require("characters.ships.enemies.enemyShip")
local enemySpawner = require("characters.ships.enemies.enemySpawner")

local camera = require("level.camera")
local background = require("level.background")
require("characters.ships.player.ship")
sceneGame.saved_data = nil
Pause_game = false
local deathUI = {}

sceneGame.load = function()
    
    background.load()
    if sceneGame.saved_data then
        EnemyShips = sceneGame.saved_data.EnemyShips
        Buttons = sceneGame.saved_data.Buttons
        Projectiles = sceneGame.saved_data.Projectiles
        PlayerShip = sceneGame.saved_data.PlayerShip
        enemySpawner.load()
    else
        sceneGame.restart()
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
    enemySpawner.update(dt)
    if PlayerShip.is_dead then
        Pause_game = true
        sceneGame.restart()
    end
end

local function update_ui(dt)
    Buttons.update(dt)
end


sceneGame.update = function(dt)
    if Pause_game == true then
        if PlayerShip.is_dead == false then
            PlayerShip.upgrades.update()
            if love.keyboard.isScancodeDown("return") then
                Pause_game = false
                PlayerShip.upgrades.delete_choices()
            end
        else
        end
    else
        update_game(dt)
    end
    
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
    if Pause_game==false and love.keyboard.isScancodeDown("t") then
        Pause_game = true
        PlayerShip.upgrades.create_weapon_choices()
    end
end

sceneGame.moussepressed = function(x, y, button)
    Buttons.mousepressed(x, y, button)
end

sceneGame.restart = function()
    Buttons.unload()
    EnemyShips.unload()
    Projectiles.unload()
    PlayerShip = newPlayerShip()
    PlayerShip.load()
    deathUI = require("ui.death_ui")
end



return sceneGame