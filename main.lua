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

function setWindowSize()
    if devMode == true then
        love.window.setMode(devWidth, devHeight)
        SCALE = 1
    else
        local monitorWidth, monitorHeight = love.window.getDesktopDimensions(monitorIndex)
        local offset = 200
        monitorWidth = monitorWidth - offset
        monitorHeight = monitorHeight - offset

        local ratio = devWidth/devHeight

        love.window.setMode(monitorWidth, monitorHeight)
        SCALE = math.min(monitorWidth/devWidth, monitorHeight/devHeight)
    end
    ScreenWidth = love.graphics.getWidth() / SCALE
    ScreenHeight = love.graphics.getHeight() / SCALE
end

setWindowSize()



IMG_RAD_OFFSET = math.pi/2


require("utils.sprite")
require("utils.vector2")
require("utils.math")
require("utils.copy")
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
    love.graphics.scale(SCALE,SCALE)
    drawCurrentScene()

end

function love.keypressed(key)
    keypressed(key)
    if key == "escape" then
        devMode = not devMode
        setWindowSize()
    end
end

