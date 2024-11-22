local inventory = {}
inventory.weapons = {}
inventory.buttons = {}

inventory.add_weapon = function(weapon_type)
    if not inventory.has_weapon(weapon_type) then
        local key = #inventory.weapons + 1
        local weapon = newWeapon(weapon_type)
        inventory.weapons[key]=  weapon
        local weapon_pickup = newPickup(weapon_type)
        inventory.buttons[key] = newQuadButton(
            newVector2(weapon_pickup.sprite.width*(key-1), ScreenHeight-weapon_pickup.sprite.height),
            weapon_pickup.sprite,
            key,
            newVector2(0,-25)
        )
        inventory.buttons[key].img.fps = 0
        PlayerShip.switch_weapon(key)
    end
end

inventory.upgrade_weapon = function(weapon_type, upgrade_type, ugrade_value)
    for i, weapon in ipairs(inventory.weapons) do
        if weapon.type == weapon_type then
            if upgrade_type == UPGRADE_SHOOTING_SPEED then
                weapon.increase_fire_rate(ugrade_value)
            elseif upgrade_type == UPGRADE_DAMAGE then
                weapon.increase_damage(ugrade_value)
            elseif upgrade_type == UPGRADE_PROJECTILE_SPEED then
                weapon.increase_projectile_speed(ugrade_value)
            end
        end
    end
end

inventory.has_weapon = function(weapon_type)
    for i, weapon in ipairs(inventory.weapons) do
        if weapon.type == weapon_type then
            return weapon
        end
    end
    return nil
end



return inventory
