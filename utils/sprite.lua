function newSprite(img, ncquad, nlquad, wquad, hquad,fps)
    -- If quad informations is filled, sprite will be drawn from quad at fps speed
    -- else image will be static

    local sprite = {}
    sprite.img = love.graphics.newImage(img)
    sprite.width = sprite.img:getWidth()
    sprite.height = sprite.img:getHeight()
    sprite.quad = nil
    sprite.fps = fps
    sprite.time_last_update = 0
    sprite.frame = 1

    if ncquad and nlquad and wquad and hquad then
        sprite.total_width = sprite.width
        sprite.total_height = sprite.height
        sprite.width = wquad
        sprite.height = hquad
        sprite.quad = {}
        local id = 1
        for l=1,nlquad do
            for c=1, ncquad do
                sprite.quad[id] = love.graphics.newQuad((c-1) * wquad, (l-1) * hquad, wquad, hquad, sprite.total_width, sprite.total_height)
                id = id + 1
            end
        end
        sprite.nframes = #sprite.quad
    end

    sprite.update = function(dt)
        if sprite.fps then
            sprite.time_last_update = sprite.time_last_update + dt
            if sprite.time_last_update > 1 / sprite.fps then
                sprite.frame = sprite.frame + 1
                sprite.time_last_update = 0
                if sprite.frame > sprite.nframes then
                    sprite.frame = 1
                end
            end
        end
    end


    sprite.draw = function(pos, rad, scale, offset)
        local d_pos = pos or newVector2()
        local d_rad = rad or 0
        local d_scale = scale or newVector2(1,1)
        local d_offset = offset or newVector2(sprite.width * 0.5, sprite.height * 0.5)
        if sprite.quad then
            love.graphics.draw(sprite.img, sprite.quad[sprite.frame], d_pos.x, d_pos.y, d_rad, d_scale.x, d_scale.y, d_offset.x, d_offset.y)
        else
            love.graphics.draw(sprite.img, d_pos.x, d_pos.y, d_rad, d_scale.x, d_scale.y, d_offset.x, d_offset.y)
        end
    end

    return sprite
end