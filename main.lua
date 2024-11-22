-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")

local devMode = true
local devWidth = 1024
local devHeight = 736


Font = love.graphics.newFont(12)  -- Choose your font size
love.graphics.setFont(Font)
Scale = 1
local scale_increment = 0.1
local min_scale, max_scale = 0.8, 2

local function setScale()
    ScreenWidth = love.graphics.getWidth() / Scale
    ScreenHeight = love.graphics.getHeight() / Scale
end
local display_mode_params = {resizable = true, vsync = false, msaa = 4}
local function setWindowSize()
    if devMode == true then
        love.window.setMode(devWidth, devHeight, display_mode_params)
    else
        local monitorWidth, monitorHeight = love.window.getDesktopDimensions()
        local offset = 200
        monitorWidth = monitorWidth - offset
        monitorHeight = monitorHeight - offset
        love.window.setMode(monitorWidth, monitorHeight, display_mode_params)
    end
    setScale()
end

setWindowSize()

IMG_RAD_OFFSET = math.pi/2


require("utils.sprite")
require("utils.vector2")
require("utils.math")
require("utils.copy")
require("utils.timer")
require("ui.button")
require("scenes.sceneManager")
require("scenes.sceneGame")
require("scenes.sceneMenu")

function love.load()
    changeScene("game")
end

function love.update(dt)
    updateCurrentScene(dt)

end

function love.draw()
    love.graphics.scale(Scale,Scale)
    drawCurrentScene()

end

function love.keypressed(key, scancode)
    keypressed(key, scancode)
    if scancode == "escape" then
        devMode = not devMode
        setWindowSize()
    end
end

function love.mousepressed(x, y, button)
    moussepressed(x, y, button)
end

function love.wheelmoved(x, y)
    Scale = math.clamp(Scale + y*scale_increment, min_scale, max_scale)
    setScale()
end

