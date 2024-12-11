require("characters.ships.shipFactory")
require("characters.ships.enemies.enemyShip")


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
    Pause_full_game = false
    sceneGame.vortex_created = nil
    sceneGame.music_name = nil
    sceneGame.music = nil
    sceneGame.load = function(data, restart)
        if sceneGame.music_name then
            sceneGame.music = PlayMusic(sceneGame.music_name)
        end
        sceneGame.vortex_created = false
        sceneGame.update_camera()
        background.load()
        sceneGame.unload_environment()

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
        sceneGame.load_environment()
        sceneGame.update_player_pos()
    end



    sceneGame.load_enemies = function()
    end

    sceneGame.load_from_data = function(data)
        sceneGame.restart_enemies()
        PlayerShip = data.PlayerShip
        Buttons = data.Buttons
    end

    sceneGame.load_from_save = function()
        EnemyShips = sceneGame.saved_data.EnemyShips
        Buttons = sceneGame.saved_data.Buttons
        Projectiles = sceneGame.saved_data.Projectiles
        PlayerShip = sceneGame.saved_data.PlayerShip
        sceneGame.load_enemies()
    end

    sceneGame.update_player_pos = function()
    end
    sceneGame.update_camera = function()
    end

    sceneGame.unload = function()
        love.audio.stop()
        sceneGame.saved_data = sceneGame.save_data()
        Buttons.unload()
    end

    local function update_pause()
        if PlayerShip.is_dead == false then
            PlayerShip.upgrades.update()
        else
            if deathUI.button.isPressed then
                sceneGame.restart()
                Pause_game = false
            end
        end
    end

    local function debug_upgrades()
        
        if love.keyboard.isScancodeDown("t") then
            Pause_game = true
            PlayerShip.upgrades.create_choices()
        end
        if love.keyboard.isScancodeDown("v") then
            Pause_game = true
            PlayerShip.upgrades.create_weapon_choices()
        end
        if love.keyboard.isScancodeDown("y") then
            Create_boss_vortex()
        end
        if love.keyboard.isScancodeDown("h") then
            Create_survivor_vortex()
        end
    end
    
    sceneGame.update_game_without_enemies_spawn = function(dt)
        debug_upgrades()
        if MovingCamera == true then
            sceneGame.camera.update(PlayerShip.pos.x, PlayerShip.pos.y)
        end
        background.update(dt, PlayerShip.pos.x, PlayerShip.pos.y)
        PlayerShip.update(dt)
        EnemyShips.update(dt)
        Projectiles.update(dt)
        Triggers.update(dt)
        
        if PlayerShip.is_dead then
            Pause_game = true
            deathUI.create_button()
        end
    end

    sceneGame.update_game = function(dt)
        sceneGame.update_game_without_enemies_spawn(dt)
    end

    sceneGame.update_ui = function(dt)
        local mouseX, mouseY = love.mouse.getPosition()
        Buttons.update(dt, mouseX, mouseY)
    end


    sceneGame.update = function(dt)
        if Pause_full_game == false then
            if Pause_game == true then
                update_pause()
            else
                sceneGame.update_game(dt)
            end
            
            sceneGame.update_ui(dt)
        end
    end

    local function draw_game()
        love.graphics.push()
        if MovingCamera == true then
            sceneGame.camera.move()
        end
        background.draw()
        Triggers.draw()
        EnemyShips.draw()
        PlayerShip.draw()
        Projectiles.draw()
        love.graphics.pop()
    end

    local function draw_ui()
        Buttons.draw()
    end

    local function draw_pause()
        if Pause_full_game == true then
            local font = love.graphics.newFont(48)  -- Choose your font size
            love.graphics.setFont(font)
            local text = "Game is Paused\n\nPress Escape to Resume"
            local textWidth = font:getWidth(text)

            local textHeight = font:getHeight(text) * (select(2, text:gsub("\n", "\n"))+1)
            love.graphics.printf(text, (ScreenWidth-textWidth) * 0.5, (ScaledScreenHeight - textHeight) * 0.5, textWidth, "center")
            love.graphics.setFont(Font)
        end
    end

    sceneGame.draw = function()
        draw_game()
        love.graphics.origin()
        draw_ui()
        draw_pause()
        
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
        sceneGame.load_enemies()
    end
    
    sceneGame.load_environment = function()
    end
    
    sceneGame.unload_environment = function()
        Triggers.unload()
    end


    sceneGame.restart = function()
        sceneGame.vortex_created = false
        Buttons.unload()
        sceneGame.unload_environment()
        sceneGame.restart_enemies()
        PlayerShip = newPlayerShip()
        PlayerShip.load()
        -- Go to start scene
        if sceneGame.title ~= "gameSurvivor" then
            sceneGame.save_and_change_scene("gameSurvivor")
        end
        
    end

    sceneGame.save_and_change_scene = function(title)
        local data = sceneGame.save_change_scene_data()
        changeScene(title, data)
    end

    sceneGame.change_to_boss_scene = function()
        sceneGame.save_and_change_scene("gameBoss")
    end

    sceneGame.change_to_survivor_scene = function()
        sceneGame.save_and_change_scene("gameSurvivor")
    end
    sceneGame.pause_music = function(scancode)
        if scancode == "p" then

            if sceneGame.music:isPlaying() then
                love.audio.pause()
            else
                sceneGame.music:play()
            end
        end
    end

    sceneGame.pause_game = function(scancode)
        if scancode == "escape" then
            Pause_full_game = not Pause_full_game
        end
    end


    sceneGame.keypressed = function(key, scancode)
        sceneGame.pause_music(scancode)
    end


    return sceneGame
end

