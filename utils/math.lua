-- Retourne la distance entre deux points
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

function math.vdist(v1, v2) return (v1-v2).norm() end

-- Renvoie l'angle entre deux vecteurs supposant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end

-- Function to clamp a value
function math.clamp(value, min, max)
    if value < min then
        return min
    elseif value > max then
        return max
    else
        return value
    end
end

function Lerp(from, to, speed)
    return from + (to - from) * speed
end

function LerpAngle(from, to, speed)
    -- Calculate the difference making sure you always take the shortest angle path
    local delta = (to - from + math.pi) % (math.pi*2) - math.pi
    return (from + delta * speed)
end

function SmoothLookAt(source, target, rad, lerp_speed, dt)
    local target_rad = math.angle(source.x, source.y, target.x, target.y)
    local output_rad = LerpAngle(rad, target_rad, lerp_speed * dt)
    local moving_dir = newVector2FromRad(output_rad)
    return output_rad, moving_dir
end

function RandomFloat(min, max)
    return min + math.random() * (max - min)
end

function RandomDirection()
    return math.random(0, 1) == 0 and -1 or 1
end
