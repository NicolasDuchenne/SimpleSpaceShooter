local background = {}

local backgroundLayers = {}
local layers = {}
local ncquad = 9
local nlquad = 1
local qwidth = 640
local qheight = 360
local fps = 10
local scale = newVector2(1,1)
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 01 - Void.png", speed = 0.2})
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 02 - Stars.png", speed = 0.5})
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 03 - Stars.png", speed = 1})

background.load = function()
    -- Load background images (far, middle, near)
    for i, layer in ipairs(layers) do
        backgroundLayers[i] = {sprite = newSprite(layer.img_name, ncquad, nlquad, qwidth, qheight, fps), speed = layer.speed}
    end
end

background.update = function(dt)
    for _, layer in ipairs(backgroundLayers) do
        layer.sprite.update(dt)
    end
end

background.draw = function(x, y)
    for _, layer in ipairs(backgroundLayers) do

        -- Draw the layer image, tiling it if necessary, with an offset from player's position
        local offset_x = x * layer.speed
        local offset_y = y * layer.speed
        local width = layer.sprite.width * scale.x
        local height = layer.sprite.height * scale.y
        for l = math.floor((x-ScreenWidth)/width) * width, x + width + ScreenWidth, width do
            for c = math.floor((y-ScreenHeight)/height) * height, y + height + ScreenHeight, height do
                layer.sprite.draw(newVector2(-(offset_x%width) + l, -(offset_y%height) + c), 0, scale)
            end
        end

    end
end

return background