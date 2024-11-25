-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


Font = love.graphics.newFont(18)  -- Choose your font size
love.graphics.setFont(Font)
Scale = 1
local scale_increment = 0.1
local min_scale, max_scale = 0.8, 2

local function setScale()
    ScreenWidth = love.graphics.getWidth()
    ScreenHeight = love.graphics.getHeight()
    ScaledScreenWidth = ScreenWidth / Scale
    ScaledScreenHeight = ScreenHeight / Scale
end
local display_mode_params = {resizable = false, vsync = false, msaa = 4}

local monitorWidth, monitorHeight = love.window.getDesktopDimensions()
local offset = 200
monitorWidth = monitorWidth - offset
monitorHeight = monitorHeight - offset
love.window.setMode(monitorWidth, monitorHeight, display_mode_params)
-- end
setScale()



IMG_RAD_OFFSET = math.pi/2


require("utils.sprite")
require("utils.vector2")
require("utils.math")
require("utils.copy")
require("utils.timer")
require("ui.button")
require("scenes.sceneManager")
require("scenes.sceneGame")
require("scenes.sceneGameMovingCamera")
require("scenes.sceneGameStaticCamera")
require("scenes.sceneMenu")

function love.load()
    math.randomseed(os.time())
    changeScene("menu")
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
end

function love.mousepressed(x, y, button)
    moussepressed(x, y, button)
end

function love.wheelmoved(x, y)
    Scale = math.clamp(Scale + y*scale_increment, min_scale, max_scale)
    setScale()
end

function love.resize(x, y)
    setScale()
end

