Buttons = {}
Buttons.unload = function()
    for i=#Buttons, 1, -1 do
        table.remove(Buttons, i)
    end
end

Buttons.update = function(dt, x, y)
    for i=#Buttons, 1, -1 do
        local button = Buttons[i]
        if button.update then
            button.update(dt, x, y)
        end
        if button.isPressed == true and button.callback then
            button.callback()
        end
        if button.remove == true then
            table.remove(Buttons, i)
        end
    end
end

Buttons.draw = function()
    for i, button in ipairs(Buttons) do
        button.draw()
    end
end

Buttons.mousepressed = function(button)
    for i, cbutton in ipairs(Buttons) do
        cbutton.isMoussePressed(button)
    end
end


function newButton(pos, size, text, text_offset, callback)
    local button = {}
    button.pos = pos
    button.size = size
    button.text = text
    button.remove = false
    button.isPressed = false
    button.isHovered = false
    button.callback = callback
    
    local function update_size_from_text()
        text_offset = text_offset or newVector2()
        if text then
            button.textWidth = Font:getWidth(button.text)
            button.textHeight = Font:getHeight(button.text)

            button.number_of_line = (select(2, tostring(button.text):gsub("\n", "\n"))+1)

            button.size = newVector2(math.max(button.size.x, button.textWidth), math.max(button.size.y, button.textHeight))
        end
        
        button.content_pos = button.pos + button.size/2
    end
    update_size_from_text()

    button.delete = function()
        button.remove = true
    end

    button.set_text = function(text)
        button.text = text
        update_size_from_text()
    end

    button.checkIsHovered = function(x, y)
        button.isHovered = false
        if x > button.pos.x and x < button.pos.x + button.size.x and 
        y > button.pos.y and y < button.pos.y + button.size.y then
            button.isHovered = true
        end
    end

    button.isMoussePressed = function(pButton)
        --button.checkIsHovered(x, y)
        if button.isHovered and pButton == 1 then
            button.isPressed = true
        end

    end

        
    button.update = function(dt, x, y)
        button.checkIsHovered(x, y)
    end

    button.draw_text = function()
        if button.text then
            love.graphics.setColor(0, 0, 0, 0.8)
            love.graphics.rectangle("fill", button.content_pos.x -  (button.textWidth/2 - text_offset.x), button.content_pos.y - (button.textHeight/2 - text_offset.y), button.textWidth, button.textHeight* button.number_of_line)
            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.print(button.text, button.content_pos.x, button.content_pos.y, 0, 1, 1, button.textWidth/2 - text_offset.x, button.textHeight/2 - text_offset.y)
        end
    end
    table.insert(Buttons, button)
    return button
end

function newImgButton(pos, sprite, text, text_offset, size, scale, callback)
    scale = scale or newVector2(1,1)
    size = size or newVector2()
    local img = sprite
    local tmp_size = newVector2(math.max(size.x,img.width*scale.x), math.max(size.y,img.height*scale.y))
    local button = newButton(pos, tmp_size, text, text_offset, callback)
    button.img = img

    button.update = function(dt, x, y)
        button.checkIsHovered(x, y)
    end

    button.draw = function()
        love.graphics.setColor(0, 0, 0, 0.5)
        if button.isHovered == true then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos, 0, scale)
        
        button.draw_text()
    end
    return button
end

function newQuadButton(pos, quadSprite, text, text_offset, size, scale, callback)
    local button = newImgButton(pos, quadSprite, text, text_offset, size, scale, callback)

    button.update = function(dt, x, y)
        button.checkIsHovered(x, y)
        button.img.update(dt)
    end

    return button
end

function newTextButton(pos, size, text, text_offset, fill, callback)
    fill = fill or false
    local button = newButton(pos,size, text, text_offset, callback)

    button.draw = function()
        if fill == true then
            love.graphics.setColor(0, 0, 0, 0.5)
            if button.isHovered == true then
                love.graphics.setColor(1, 1, 1, 0.5)
            end
            love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
            love.graphics.setColor(1, 1, 1, 1)
        end
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.draw_text()
    end
    return button
end

