Buttons = {}

Buttons.update = function()
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


function newButton(pos, size)
    local button = {}
    button.pos = pos
    button.size = size
    button.content_pos = button.pos + button.size/2

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
    
    table.insert(Buttons, button)
    return button
end

function newImgButton(pos, sprite)
    
    local img = sprite
    local size = newVector2(img.width, img.height)
    local button = newButton(pos, size)
    button.img = img

    button.draw = function()
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        button.img.draw(button.content_pos)
    end
    return button
end

function newQuadButton(pos, quadSprite)
    local img = quadSprite
    local size = newVector2(img.width, img.height)
    local button = newButton(pos, size)
    button.img = img
    print(button.pos.x)
    print(button.pos.y)


    button.draw = function()
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle("fill", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.setColor(1, 1, 1, 255)
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        -- Warning !!! On passe la frame car le deep copy ne semble pas fonctionner correctement, TODO explorer
        button.img.draw(button.content_pos, 0, newVector2(1,1), newVector2(button.img.width/2, button.img.width/2), button.img.frame)
    end
    return button
end

function newTextButton(pos, size, text)
    local button = newButton(pos,size)

    local textWidth = Font:getWidth(text)
    local textHeight =Font:getHeight(text)
    button.draw = function()
        love.graphics.rectangle("line", button.pos.x, button.pos.y, button.size.x, button.size.y)
        love.graphics.print(text, button.content_pos.x, button.content_pos.y, 0, 1, 1, textWidth/2, textHeight/2)
    end
    return button
end

