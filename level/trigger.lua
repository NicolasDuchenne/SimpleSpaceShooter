Triggers = {}

Triggers.unload = function()
    for i=#Triggers, 1, -1 do
        table.remove(Triggers, i)
    end
end

Triggers.update = function(dt)
    for i=#Triggers, 1, -1 do
        local trigger = Triggers[i]
        trigger.update(dt)
    end
end

Triggers.draw = function()
    for i=#Triggers, 1, -1 do
        local trigger = Triggers[i]
        trigger.draw()
    end
end

function newTrigger(pos, sprite, size, scale, radius, text, callback)
    local trigger = {}
    scale = scale or newVector2(1,1)
    size = size or newVector2()
    local img = sprite
    local tmp_size = newVector2(math.max(size.x,img.width*scale.x), math.max(size.y,img.height*scale.y))
    trigger.img = img
    trigger.size = tmp_size
    trigger.scale = scale
    trigger.content_pos = pos + trigger.size/2
    trigger.callback = callback
    trigger.text = text
    trigger.arrow_rad = 0
    trigger.arrow_lerp_speed = 5
    trigger.arrow_length = 60
    trigger.arrow_width = 2
    if trigger.text then
        trigger.textWidth = Font:getWidth(text)
        trigger.textHeight = Font:getHeight(text)
    end

    trigger.set_callback = function(new_callback)
        trigger.callback = new_callback
    end

    trigger.update = function(dt)
        local moving_dir = newVector2()
        trigger.img.update(dt)
        if trigger.callback then
            if math.vdist(PlayerShip.pos, trigger.content_pos) < PlayerShip.hitbox_radius + radius then
                trigger.callback()
            end
        end
        trigger.arrow_rad, moving_dir = SmoothLookAt(PlayerShip.pos, trigger.content_pos, trigger.arrow_rad, trigger.arrow_lerp_speed, dt)
    end

    trigger.draw = function()
        trigger.img.draw(trigger.content_pos, 0, trigger.scale)
        love.graphics.circle("line", trigger.content_pos.x, trigger.content_pos.y, radius)
        if trigger.text then
            love.graphics.print(text, PlayerShip.pos.x- trigger.textWidth * 0.5, PlayerShip.pos.y - 4 * trigger.textHeight)
        end
        love.graphics.arrow(PlayerShip.pos.x, PlayerShip.pos.y, trigger.arrow_rad,trigger.arrow_length, trigger.arrow_width)
    end
    table.insert(Triggers, trigger)
    return trigger
end