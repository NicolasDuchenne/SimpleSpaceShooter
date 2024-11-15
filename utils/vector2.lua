function newVector2(px,py)
    local v = {}
    v.x = px or 0
    v.y = py or 0
  
    local vectorMT = {}
  
    -- ce que renvoie la fonction print
    --function vecteurMetaTable.__tostring(v)  
    --    return "("..v.x..","..v.y..")"
    --end
  
    function vectorMT.__add(v1,v2)  -- operateur +
      local sum = newVector2(0,0)
      sum.x = v1.x + v2.x
      sum.y = v1.y + v2.y
      return sum
    end
  
    function vectorMT.__sub(v1,v2) -- operateur binaire -
      local sum = newVector2(0,0)
      sum.x = v1.x - v2.x
      sum.y = v1.y - v2.y
      return sum
    end
  
    function vectorMT.__unm(v) -- operateur unaire -
      local oppose = newVector2(-v.x,-v.y)
      return oppose
    end
  
    function vectorMT.__mul(k,v) -- operateur *
      local vect = newVector2(0,0)
      if type(k)=="number" then
        vect.x = k*v.x
        vect.y = k*v.y
      else
        vect.x = v*k.x
        vect.y = v*k.y
      end
      return vect
    end
  
    setmetatable(v,vectorMT)
  
    v.normSquared = function()  -- norme au carre d'un vecteur
      return v.x^2+v.y^2
    end
  
    v.norm = function() -- norme d'une vecteur
      return math.sqrt(v.x^2+v.y^2) 
    end
  
    v.normalize= function() -- fait de v un vecteur unitaire ( de norme 1 )
      local norm = v.norm()
      v.x = v.x/norm
      v.y = v.y/norm
    end
  
    --*********************************************************************************************************
    --* le determinant de u et de v est un réel                                                               *
    --* il vaut 0 si et seulement si u et v sont colinaires  cad si et seulement si ils ont la même direction *
    --*********************************************************************************************************
    v.det  = function(u)  
      return v.x * u.y - u.x * v.y
    end
  
    --**********************************************************************************
    --* le produit  scalaire de u et v est un réel                                     *
    --* il calcule "l'influence" du vecteur u dans la direction v                      *
    --* le u.v = 0 si et seulement si u et v sont orthogonaux (forment un angle droit) *
    --**********************************************************************************
    v.scalaire= function(u)
      return u.x * v.x + u.y * v.y
    end
    
    return v
  end