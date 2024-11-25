require("characters.ships.shipFactory")
require("characters.ships.enemies.enemyShip")
local enemySpawner = require("characters.ships.enemies.enemySpawner")
local camera = require("level.camera")
local background = require("level.background")
require("characters.ships.player.ship")

local deathUI = require("ui.death_ui")

MovingCamera = false

function newScenegame(title)
    local sceneGame = newScene(title)
    sceneGame.title = title
    sceneGame.camera = camera
    sceneGame.saved_data = nil
    Pause_game = false

    sceneGame.load = function(data, restart)
        sceneGame.update_camera()
        background.load()
        restart = restart or false
        if restart then
            sceneGame.restart()
        elseif data then
            sceneGame.load_from_data(data)
        elseif sceneGame.saved_data then
            sceneGame.load_from_save()
        else
            sceneGame.restart()
        end
        sceneGame.update_player_pos()
    end

    sceneGame.load_from_data = function(data)
        sceneGame.restart_enemies()
        PlayerShip = data.PlayerShip
        Buttons = data.Buttons
        enemySpawner.load()
    end

    sceneGame.load_from_save = function()
        EnemyShips = sceneGame.saved_data.EnemyShips
        Buttons = sceneGame.saved_data.Buttons
        Projectiles = sceneGame.saved_data.Projectiles
        PlayerShip = sceneGame.saved_data.PlayerShip
        enemySpawner.load()
    end

    sceneGame.update_player_pos = function()
    end
    sceneGame.update_camera = function()
    end

    sceneGame.unload = function()
        sceneGame.saved_data = sceneGame.save_data()
        Buttons.unload()
    end

    local function update_pause()
        if PlayerShip.is_dead == false then
            PlayerShip.upgrades.update()
        else
            if deathUI.button.isPressed then
                sceneGame.restart()
            end
        end
    end

    local function update_game(dt)
        if MovingCamera == true then
            sceneGame.camera.update(PlayerShip.pos.x, PlayerShip.pos.y)
        end
        background.update(dt, PlayerShip.pos.x, PlayerShip.pos.y)
        PlayerShip.update(dt)
        EnemyShips.update(dt)
        Projectiles.update(dt)
        enemySpawner.update(dt)
        if PlayerShip.is_dead then
            Pause_game = true
            deathUI.create_button()
            --sceneGame.restart()
        end
    end

    local function update_ui(dt)
        local mouseX, mouseY = love.mouse.getPosition()
        Buttons.update(dt, mouseX, mouseY)
    end


    sceneGame.update = function(dt)
        if Pause_game == true then
            update_pause()
        else
            update_game(dt)
        end
        
        update_ui(dt)
    end

    local function draw_game()
        love.graphics.push()
        if MovingCamera == true then
            sceneGame.camera.move()
        end
        background.draw()
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

    sceneGame.save_change_scene_data = function()
        local data = {}
        data.PlayerShip = PlayerShip
        data.Buttons = DeepCopy(Buttons)
        return data
    end

    sceneGame.save_data = function()
        local data = sceneGame.save_change_scene_data()
        data.EnemyShips = EnemyShips
        data.Projectiles = Projectiles
        return data
    end  

    sceneGame.moussepressed = function(x, y, button)
        Buttons.mousepressed(button)
    end

    sceneGame.restart_enemies = function()
        EnemyShips.unload()
        Projectiles.unload()
        enemySpawner.load()
    end

    sceneGame.restart = function()
        Buttons.unload()
        sceneGame.restart_enemies()
        PlayerShip = newPlayerShip()
        PlayerShip.load()
        -- Go to start scene
        if sceneGame.title ~= "gameMovingCamera" then
            sceneGame.save_and_change_scene("gameMovingCamera")
        end
        
    end

    sceneGame.save_and_change_scene = function(title)
        local data = sceneGame.save_change_scene_data()
        changeScene(title, data)
    end



    return sceneGame
end

