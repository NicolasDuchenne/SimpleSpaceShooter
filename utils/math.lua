-- Retourne la distance entre deux points
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Renvoie l'angle entre deux vecteurs supposant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

function Lerp(from, to, speed)
    return from + (to - from) * speed
end


function LerpAngle(from, to, speed)
    -- Calculate the difference making sure you always take the shortest angle path
    local delta = (to - from + math.pi) % (math.pi*2) - math.pi
    return (from + delta * speed)
end