local scenes = {}
function newScene(title)
    local scene = {}
    scene.title = title

    scene.update = function(dt)
    end

    scene.draw = function()
    end

    scene.load = function(data)
    end

    scene.unload = function()

    end
    scenes[title] = scene
    return scene
end

local currentScene = nil

function changeScene(title, data)
    if currentScene~=nil then
        currentScene.unload()
    end
    if not scenes[title] then
        error("scene "..title.." not loaded, add require for this scene")
    end
    currentScene = scenes[title]
    currentScene.load(data)

end

function updateCurrentScene(dt)
    currentScene.update(dt)
end

function drawCurrentScene()
    currentScene.draw()
end

function keypressed(key)
    currentScene.keypressed(key)
end


function mousePressed(x, y, button)
    currentScene.mousePressed(x, y, button)
end