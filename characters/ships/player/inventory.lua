local inventory = {}
inventory.weapons = {}
inventory.buttons = {}

inventory.add_weapon = function(weapon_name, key)
    local weapon = newWeapon(weapon_name)
    inventory.weapons[key]=  weapon
    inventory.buttons[key] = newQuadButton(newVector2(0, 0), DeepCopy(weapon.current_base_sprite))
end

inventory.update = function(pos)
    for i, button in ipairs(inventory.buttons) do
        button.update(pos + newVector2(button.size.x*(i-1), -button.size.y))
    end
end

inventory.draw = function()
    for i, button in ipairs(inventory.buttons) do
        button.draw()    
    end
end



return inventory
