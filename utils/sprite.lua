SPRITE_PLAY_ONCE = "play_once"
SPRITE_REPEAT = "repeat"

function newSprite(img, color)
    -- If quad informations is filled, sprite will be drawn from quad at fps speed
    -- else image will be static

    local sprite = {}
    sprite.img = love.graphics.newImage(img)
    sprite.width = sprite.img:getWidth()
    sprite.height = sprite.img:getHeight()
    sprite.color = color or nil

    sprite.draw = function(pos, rad, scale, offset)
        local d_pos = pos or newVector2()
        local d_rad = rad or 0
        local d_scale = scale or newVector2(1,1)
        local d_offset = offset or newVector2(sprite.width * 0.5, sprite.height * 0.5)
        if sprite.color then
            love.graphics.setColor(sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a or 1)
        end
        love.graphics.draw(sprite.img, d_pos.x, d_pos.y, d_rad, d_scale.x, d_scale.y, d_offset.x, d_offset.y)
        if sprite.color then
            love.graphics.setColor(1,1,1,1)
        end

    end

    return sprite
end

function newQuadSprite(img, ncquad, nlquad, wquad, hquad,fps, color, play_mode)
    -- If quad informations is filled, sprite will be drawn from quad at fps speed
    -- else image will be static

    local sprite = {}
    sprite.img = love.graphics.newImage(img)
    sprite.total_width = sprite.img:getWidth()
    sprite.total_height = sprite.img:getHeight()
    sprite.quad = nil
    sprite.fps = fps or 0
    sprite.color = color or nil
    sprite.play_mode = play_mode or SPRITE_REPEAT
    sprite.time_last_update = 0
    sprite.frame = 1
    sprite.width = wquad
    sprite.height = hquad
    sprite.quad = {}
    sprite.play_sprite = false


    local id = 1
    for l=1,nlquad do
        for c=1, ncquad do
            sprite.quad[id] = love.graphics.newQuad((c-1) * wquad, (l-1) * hquad, wquad, hquad, sprite.total_width, sprite.total_height)
            id = id + 1
        end
    end
    sprite.nframes = #sprite.quad

    sprite.update = function(dt)
        if sprite.play_mode == SPRITE_REPEAT or sprite.play_mode == SPRITE_PLAY_ONCE and sprite.play_sprite == true then
            sprite.time_last_update = sprite.time_last_update + dt
            if sprite.time_last_update > 1 / sprite.fps then
                sprite.frame = sprite.frame + 1
                sprite.time_last_update = 0
                if sprite.frame > sprite.nframes then
                    sprite.reset()
                end
            end
        end
         
    end

    sprite.reset = function()
        sprite.play_sprite = false
        sprite.frame = 1
        sprite.time_last_update = 0
    end



    sprite.draw = function(pos, rad, scale, offset, frame)
        local d_pos = pos or newVector2()
        local d_rad = rad or 0
        local d_scale = scale or newVector2(1,1)
        local d_offset = offset or newVector2(sprite.width * 0.5, sprite.height * 0.5)
        local d_frame = frame or sprite.frame
        if sprite.color then
            love.graphics.setColor(sprite.color.r, sprite.color.g, sprite.color.b, sprite.color.a or 1)
        end
        love.graphics.draw(sprite.img, sprite.quad[d_frame], d_pos.x, d_pos.y, d_rad, d_scale.x, d_scale.y, d_offset.x, d_offset.y)
        
        if sprite.color then
            love.graphics.setColor(1,1,1,1)
        end
    end

    return sprite
end