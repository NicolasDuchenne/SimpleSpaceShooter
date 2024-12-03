local max = 255
function newColor(r, g, b, a)
    return {r=r/max, g=g/max, b=b/max, a=a or 1}
end