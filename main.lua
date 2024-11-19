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

local function setWindowSize()
    if devMode == true then
        love.window.setMode(devWidth, devHeight)
        Scale = 1
    else
        local monitorWidth, monitorHeight = love.window.getDesktopDimensions(monitorIndex)
        local offset = 200
        monitorWidth = monitorWidth - offset
        monitorHeight = monitorHeight - offset

        local ratio = devWidth/devHeight

        love.window.setMode(monitorWidth, monitorHeight)
        Scale = math.min(monitorWidth/devWidth, monitorHeight/devHeight)
    end
    ScreenWidth = love.graphics.getWidth() / Scale
    ScreenHeight = love.graphics.getHeight() / Scale
end

setWindowSize()



IMG_RAD_OFFSET = math.pi/2


require("utils.sprite")
require("utils.vector2")
require("utils.math")
require("utils.copy")
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

