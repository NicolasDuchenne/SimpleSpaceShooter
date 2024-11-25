local background = {}

local backgroundLayers = {}
local layers = {}
local ncquad = 9
local nlquad = 1
local qwidth = 640
local qheight = 360
local fps = 10
local scale = newVector2(1.5,1.5)
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 01 - Void.png", speed = 0})
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 02 - Stars.png", speed = 0.1})
table.insert(layers, {img_name = "assets/Void_EnvironmentPack/Backgrounds/PNGs/Condesed/Starry background  - Layer 03 - Stars.png", speed = 0.2})


background.load = function()
    -- Load background images (far, middle, near)
    for i, layer in ipairs(layers) do
        backgroundLayers[i] = {sprite = newQuadSprite(layer.img_name, ncquad, nlquad, qwidth, qheight, fps), speed = layer.speed}
        backgroundLayers[i].x = 0
        backgroundLayers[i].y = 0
        backgroundLayers[i].width = backgroundLayers[i].sprite.width * scale.x
        backgroundLayers[i].height = backgroundLayers[i].sprite.height * scale.y
        backgroundLayers[i].offset_x = 0
        backgroundLayers[i].offset_y = 0

    end
end

background.update = function(dt ,x , y)
    for _, layer in ipairs(backgroundLayers) do
        layer.x = x
        layer.y = y
        -- Draw the layer image, tiling it if necessary, with an offset from player's position
        layer.offset_x = 0
        layer.offset_y = 0
        if MovingCamera == true then
            layer.offset_x = layer.x * layer.speed
            layer.offset_y = layer.y * layer.speed
        end
        layer.width = layer.sprite.width * scale.x
        layer.height = layer.sprite.height * scale.y
        layer.sprite.update(dt)
    end
end

background.draw = function()
    for _, layer in ipairs(backgroundLayers) do
        for l = math.floor((layer.x-ScreenWidth)/layer.width) * layer.width, layer.x + layer.width + ScreenWidth, layer.width do
            for c = math.floor((layer.y-ScaledScreenHeight)/layer.height) * layer.height, layer.y + layer.height + ScaledScreenHeight, layer.height do
                layer.sprite.draw(newVector2(-(layer.offset_x%layer.width) + l, -(layer.offset_y%layer.height) + c), 0, scale)
            end
        end

    end
end

return background