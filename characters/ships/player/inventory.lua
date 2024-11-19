local inventory = {}
inventory.weapons = {}
inventory.buttons = {}

inventory.add_weapon = function(weapon_name, pickup_name, key)
    local weapon = newWeapon(weapon_name)
    inventory.weapons[key]=  weapon
    local weapon_pickup = newPickup(pickup_name)
    inventory.buttons[key] = newQuadButton(
        newVector2(weapon_pickup.sprite.width*(key-1), ScreenHeight-weapon_pickup.sprite.height),
        weapon_pickup.sprite,
        key,
        newVector2(0,-25)
    )
    inventory.buttons[key].img.fps = 0
end



return inventory
