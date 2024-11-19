Buttons = {}
Buttons.unload = function()
    for i=#Buttons, 1, -1 do
        table.remove(Buttons, i)
    end
end

Buttons.update = function(dt)
    for i, button in ipairs(Buttons) do
        if button.update then
            button.update(dt)
        end
    end
end

Buttons.draw = function()
    for i, button in ipairs(Buttons) do
        button.draw()
    end
end
Buttons.mousepressed = function(x, y, button)
    for i, cbutton in ipairs(Buttons) do
        cbutton.isMouseIn(x, y)
    end
end


function newButton(pos, size, text, text_offset)
    local button = {}
    button.pos = pos
    button.size = size
    button.content_pos = button.pos + button.size/2
    button.text = text
    text_offset = text_offset or newVector2()
    if text then
        
        button.textWidth = Font:getWidth(text)
        button.textHeight = Font:getHeight(text)
    end

    button.isMouseIn = function(x, y)
        if x > button.pos.x and x < button.pos.x + button.size.x and 
        y > button.pos.y and y < button.pos.y + button.size.y then
            print("mouse is in")
        end
    end

    button.update = function(new_pos)
        button.pos = new_pos or button.pos
        button.content_pos = button.pos + button.size/2
    end

    button.draw_text = function()
        if button.text then
            love.graphics.print(button.text, button.content_pos.x, button.content_pos.y, 0, 1, 1, button.textWidth/2 - text_offset.x, button.textHeight/2 - text_offset.y)
        end
    end
    table.insert(Buttons, button)
    return button
end

function newImgButton(pos, sprite, text, text_offset)
    
    local img = sprite
    local size = newVector2(img.width, img.height)
    local button = newButton(pos, size, text, text_offset)
    button.img = img

    button.draw = function()
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos)
    end
    return button
end

function newQuadButton(pos, quadSprite, text, text_offset)
    local img = quadSprite
    local size = newVector2(img.width, img.height)
    local button = newButton(pos, size, text, text_offset)
    button.img = img

    button.update = function(dt)
        button.img.update(dt)
    end


    button.draw = function()
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.setColor(1, 1, 1, 255)
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos)
        button.draw_text()
    end
    return button
end

function newTextButton(pos, size, text)
    local button = newButton(pos,size, text)

    button.draw = function()
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.draw_text()
    end
    return button
end

