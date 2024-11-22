UPGRADE_GET = "get"
UPGRADE_SPEED = "speed"
UPGRADE_DAMAGE = "damage"
local upgrades_list = {}


upgrades_list[WEAPONS.player.auto_cannon] = {
    speed = {
        color = {r=0, g=1, b=0},
        increase_percentage = 20
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase_damage = 1
    }
}

upgrades_list[WEAPONS.player.big_space_gun] = {
    get =  {
        color = {r=1, g=1, b=1},
        increase_percentage = 20
    },
    speed = {
        color = {r=0, g=1, b=0},
        increase_percentage = 20
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase_damage = 1
    }
   
}


local upgrades = {}
upgrades.number_of_choice = 3
upgrades.buttons = {}
upgrades.size = newVector2(64,64)


local function create_upgrade_button(upgrade_type, weapon_type, button_index, offset)
    local weapon_upgrades = upgrades_list[weapon_type]
    local upgrade = weapon_upgrades[upgrade_type]
    local pickup = newPickup(weapon_type)
    local quadSPrite = pickup.sprite
    quadSPrite.color = upgrade.color
    upgrades.buttons[button_index] = newQuadButton(
        newVector2(ScreenWidth/2 + offset, ScreenHeight/2),
        quadSPrite,
        upgrade_type,
        newVector2(0,-20),
        upgrades.size
    )
    upgrades.buttons[button_index].weapon_type = weapon_type
    upgrades.buttons[button_index].upgrade_type = upgrade_type
    offset = offset + upgrades.buttons[button_index].size.x
    return offset
end

upgrades.create_choices = function()
    local offset = 0
    local button_index = 1
    for name, weapon_type in pairs(WEAPONS.player) do
        local weapon_upgrades = upgrades_list[weapon_type]
        if PlayerShip.inventory.has_weapon(weapon_type) == true then
            for upgrade_type, upgrade in pairs(weapon_upgrades) do
                if upgrade_type ~= UPGRADE_GET then
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset)
                    button_index = button_index + 1
                end
            end
        elseif upgrades_list[weapon_type] then
            offset = create_upgrade_button(UPGRADE_GET, weapon_type, button_index, offset)
            button_index = button_index + 1
        end
    end
end


upgrades.delete_choices = function()
    for i=#upgrades.buttons,1 , -1 do
        upgrades.buttons[i].remove = true
    end
    upgrades.buttons = {}
end


upgrades.update = function()
    for i, button in ipairs(upgrades.buttons) do
        if button.isPressed== true then
            button.isPressed = false
            Pause_game = false
            PlayerShip.upgrades.delete_choices()
            if button.upgrade_type == UPGRADE_GET then
                PlayerShip.inventory.add_weapon(button.weapon_type)
            elseif button.upgrade_type == UPGRADE_SPEED or button.upgrade_type == UPGRADE_DAMAGE then
                PlayerShip.inventory.upgrade_weapon(button.weapon_type, button.upgrade_type)
            end

            
        end
    end

end

return upgrades