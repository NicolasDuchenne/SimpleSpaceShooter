local inventory = {}
inventory.weapons = {}
inventory.buttons = {}

inventory.add_weapon = function(weapon_name, key)
    local weapon = newWeapon(weapon_name)
    inventory.weapons[key]=  weapon
    local weapon_sprite = DeepCopy(weapon.current_base_sprite)
    inventory.buttons[key] = newQuadButton(newVector2(weapon_sprite.width*(key-1), ScreenHeight-weapon_sprite.height), weapon_sprite)
end



return inventory
