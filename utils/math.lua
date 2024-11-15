-- Retourne la distance entre deux points
function math.dist(x1,y1, x2,y2) return ((x2-x1)^2+(y2-y1)^2)^0.5 end

-- Renvoie l'angle entre deux vecteurs supposant la même origine.
function math.angle(x1,y1, x2,y2) return math.atan2(y2-y1, x2-x1) end