UPGRADE_GET = "get"
UPGRADE_SHOOTING_SPEED = "shooting_speed"
UPGRADE_DAMAGE = "damage"
UPGRADE_PROJECTILE_SPEED = "projectile_speed"
local upgrades_list = {}


upgrades_list[WEAPONS.player.auto_cannon] = {
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 20
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 10
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 10
    }
    
}

upgrades_list[WEAPONS.player.big_space_gun] = {
    get =  {
        color = {r=1, g=1, b=1},
        increase = 20
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20
    }
   
}

upgrades_list[WEAPONS.player.zapper] = {
    get =  {
        color = {r=1, g=1, b=1},
        increase = 20
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20
    }
   
}

upgrades_list[WEAPONS.player.rockets] = {
    get =  {
        color = {r=1, g=1, b=1},
        increase = 20
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20
    }
   
}

local bweapons = {}
bweapons[1] = WEAPONS.player.auto_cannon
bweapons[2] = WEAPONS.player.big_space_gun
bweapons[4] = WEAPONS.player.rockets
bweapons[3] = WEAPONS.player.zapper

local bupgrades_available = {}
bupgrades_available[1] = UPGRADE_SHOOTING_SPEED
bupgrades_available[2] = UPGRADE_DAMAGE
bupgrades_available[3] = UPGRADE_PROJECTILE_SPEED


local upgrades = {}
upgrades.number_of_choice = 3
upgrades.buttons = {}
upgrades.size = newVector2(64,64)


local function create_upgrade_button(upgrade_type, weapon_type, button_index, offset, text)
    local weapon_upgrades = upgrades_list[weapon_type]
    local upgrade = weapon_upgrades[upgrade_type]
    local pickup = newPickup(weapon_type)
    local quadSPrite = pickup.sprite
    quadSPrite.color = upgrade.color
    upgrades.buttons[button_index] = newQuadButton(
        newVector2(ScreenWidth/2 + offset - upgrades.size.x * upgrades.number_of_choice / 2, ScreenHeight/2 + upgrades.size.y),
        quadSPrite,
        upgrade_type.."\n"..(text or ""),
        newVector2(0,-80),
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
    local number_of_choice_created = 0

    local weapons = DeepCopy(bweapons)
    local upgrades_available = DeepCopy(bupgrades_available)
    

    while number_of_choice_created < upgrades.number_of_choice do
        -- Chose weapon
        local weapon_index = math.random(1, #weapons)
        print(weapon_index)
        number_of_choice_created = number_of_choice_created +1
        local weapon_type = weapons[weapon_index]
        local player_weapon = PlayerShip.inventory.has_weapon(weapon_type)
        if player_weapon then
            if #upgrades_available > 0 then
                local upgrade_index = math.random(1, #upgrades_available)
                local upgrade_type = upgrades_available[upgrade_index]
                local upgrade_value = upgrades_list[weapon_type][upgrade_type].increase
                if upgrade_type == UPGRADE_SHOOTING_SPEED then
                    local text = "current: "..player_weapon.shooting_speed_increase.." \nincrease : "..upgrade_value
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, text)
                elseif upgrade_type == UPGRADE_DAMAGE then
                    local text = "current: "..player_weapon.bullet_damage_increase.." \nincrease : "..upgrade_value
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, text)
                elseif upgrade_type == UPGRADE_PROJECTILE_SPEED then
                    local text = "current: "..player_weapon.bullet_speed_increase.." \nincrease : "..upgrade_value
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, text)
                end
                if upgrade_type ~= UPGRADE_GET then
                    button_index = button_index + 1
                end
            
                table.remove(upgrades_available, upgrade_index)
            end
        elseif upgrades_list[weapon_type] then
            offset = create_upgrade_button(UPGRADE_GET, weapon_type, button_index, offset)
            button_index = button_index + 1
            table.remove(weapons, weapon_index)
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
        -- Check if an upgrade was selected, and upgrade weapon accordingly
        if button.isPressed== true then
            button.isPressed = false
            Pause_game = false
            PlayerShip.upgrades.delete_choices()
            if button.upgrade_type == UPGRADE_GET then
                PlayerShip.inventory.add_weapon(button.weapon_type)
            else
                local upgrade_value = upgrades_list[button.weapon_type][button.upgrade_type].increase
                PlayerShip.inventory.upgrade_weapon(button.weapon_type, button.upgrade_type, upgrade_value)
            end
        end
    end

end

return upgrades