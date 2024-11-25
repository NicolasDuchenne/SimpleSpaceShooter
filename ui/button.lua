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


function newButton(pos, size, text, text_offset)
    local button = {}
    button.pos = pos
    button.size = size
    button.text = text
    button.remove = false
    button.isPressed = false
    button.isHovered = false
    
    local function update_size_from_text()
        text_offset = text_offset or newVector2()
        if text then
            button.textWidth = Font:getWidth(button.text)
            button.textHeight = Font:getHeight(button.text)
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
            love.graphics.print(button.text, button.content_pos.x, button.content_pos.y, 0, 1, 1, button.textWidth/2 - text_offset.x, button.textHeight/2 - text_offset.y)
        end
    end
    table.insert(Buttons, button)
    return button
end

function newImgButton(pos, sprite, text, text_offset, size)
    size = size or newVector2()
    local img = sprite
    local tmp_size = newVector2(math.max(size.x,img.width), math.max(size.y,img.height))
    local button = newButton(pos, tmp_size, text, text_offset)
    button.img = img

    button.draw = function()
        love.graphics.setColor(0, 0, 0, 0.5)
        if button.isHovered == true then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos)
    end
    return button
end

function newQuadButton(pos, quadSprite, text, text_offset, size)
    size = size or newVector2()
    local img = quadSprite
    local tmp_size = newVector2(math.max(size.x, img.width), math.max(size.y, img.height))
    local button = newButton(pos, tmp_size, text, text_offset)
    button.img = img

    button.update = function(dt, x, y)
        button.checkIsHovered(x, y)
        button.img.update(dt)
    end


    button.draw = function()
        love.graphics.setColor(0, 0, 0, 0.5)
        if button.isHovered == true then
            love.graphics.setColor(1, 1, 1, 0.5)
        end
        love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos)
        
        button.draw_text()
    end
    return button
end

function newTextButton(pos, size, text, fill)
    fill = fill or false
    local button = newButton(pos,size, text)

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

