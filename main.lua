-- Débogueur Visual Studio Code tomblind.local-lua-debugger-vscode
if pcall(require, "lldebugger") then
    require("lldebugger").start()
end

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet d'afficher des traces dans la console pendant l'éxécution
io.stdout:setvbuf("no")


love.window.setMode(1024, 736)


ScreenWidth = love.graphics.getWidth()
ScreenHeight = love.graphics.getHeight()


require("utils.sprite")
require("utils.vector2")
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
    drawCurrentScene()

end

function love.keypressed(key)
    keypressed(key)
end

