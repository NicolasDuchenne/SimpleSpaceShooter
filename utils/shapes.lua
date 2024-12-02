love.graphics.arrow = function(x, y, rad,length, width)
    local previousLineWidth = love.graphics.getLineWidth()
    local arrow_end_x = x + math.cos(rad) * length
    local arrow_end_y = y + math.sin(rad) * length

    local arrowAngle = math.rad(30) -- 30-degree angle for the arrowhead

    local arrow_head_length = 10 * width
    -- Calculate arrowhead points
    local hx1 = arrow_end_x - arrow_head_length * math.cos(rad - arrowAngle)
    local hy1 = arrow_end_y - arrow_head_length * math.sin(rad - arrowAngle)

    local hx2 = arrow_end_x - arrow_head_length * math.cos(rad + arrowAngle)
    local hy2 = arrow_end_y - arrow_head_length * math.sin(rad + arrowAngle)
    love.graphics.setLineWidth(width)
    love.graphics.line(x, y, arrow_end_x, arrow_end_y)
    love.graphics.polygon("fill", arrow_end_x, arrow_end_y, hx1, hy1, hx2, hy2)
    love.graphics.setLineWidth(previousLineWidth)

end