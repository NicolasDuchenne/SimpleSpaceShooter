UPGRADE_GET = "get"
UPGRADE_SHOOTING_SPEED = "shooting_speed"
UPGRADE_DAMAGE = "damage"
UPGRADE_PROJECTILE_SPEED = "projectile_speed"
local upgrades_list = {}


upgrades_list[WEAPONS.player.auto_cannon] = {
    get =  {
        color = {r=1, g=1, b=1}
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10,
        max = 300
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 10,
        max = 200
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 10,
        max = 200
    }
    
}

upgrades_list[WEAPONS.player.big_space_gun] = {
    get =  {
        color = {r=1, g=1, b=1}
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10,
        max = 300
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20,
        max = 200
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20,
        max = 300
    }
   
}

upgrades_list[WEAPONS.player.zapper] = {
    get =  {
        color = {r=1, g=1, b=1}
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10,
        max = 300
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20,
        max = 300
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20,
        max = 300
    }
   
}

upgrades_list[WEAPONS.player.rockets] = {
    get =  {
        color = {r=1, g=1, b=1}
    },
    shooting_speed = {
        color = {r=0, g=1, b=0},
        increase = 10,
        max = 300
    },
    damage = {
        color = {r=1, g=0, b=0},
        increase = 20,
        max = 300
    },
    projectile_speed = {
        color = {r=0, g=0, b=1},
        increase = 20,
        max = 300
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

local function upgrade_attenuation_function(max_increase, current_increase, base_increase)
    return math.floor((max_increase - current_increase)/max_increase * base_increase)
end

local function create_upgrade_button(upgrade_type, weapon_type, button_index, offset, current_increase, max_increase, upgrade_value)
    local weapon_upgrades = upgrades_list[weapon_type]
    local upgrade = weapon_upgrades[upgrade_type]
    local pickup = newPickup(weapon_type)
    local quadSPrite = pickup.sprite
    local text = ""
    local reduced_upgrade_value = 0
    if current_increase then
        reduced_upgrade_value = upgrade_attenuation_function(max_increase, current_increase, upgrade_value)
        text = "current: "..current_increase.." \nincrease : "..reduced_upgrade_value
    end

    quadSPrite.color = upgrade.color
    upgrades.buttons[button_index] = newQuadButton(
        newVector2(ScreenWidth/2  + offset - upgrades.size.x * upgrades.number_of_choice / 2, ScreenHeight/2 + upgrades.size.y),
        quadSPrite,
        upgrade_type.."\n"..(text or ""),
        newVector2(0,-80),
        upgrades.size
    )

    upgrades.buttons[button_index].weapon_type = weapon_type
    upgrades.buttons[button_index].upgrade_type = upgrade_type
    upgrades.buttons[button_index].upgrade_value = reduced_upgrade_value
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
        number_of_choice_created = number_of_choice_created +1
        local weapon_type = weapons[weapon_index]
        local player_weapon = PlayerShip.inventory.has_weapon(weapon_type)
        -- if player has weapon, chose upgrade for weapon
        if player_weapon then
            if #upgrades_available > 0 then
                local upgrade_index = math.random(1, #upgrades_available)
                local upgrade_type = upgrades_available[upgrade_index]
                local upgrade_value = upgrades_list[weapon_type][upgrade_type].increase
                local max_upgrade = upgrades_list[weapon_type][upgrade_type].max
                if upgrade_type == UPGRADE_SHOOTING_SPEED then
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, PlayerShip.shooting_speed_increase, max_upgrade, upgrade_value)
                elseif upgrade_type == UPGRADE_DAMAGE then
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, PlayerShip.bullet_damage_increase, max_upgrade, upgrade_value)
                elseif upgrade_type == UPGRADE_PROJECTILE_SPEED then
                    offset = create_upgrade_button(upgrade_type, weapon_type, button_index, offset, PlayerShip.bullet_speed_increase, max_upgrade, upgrade_value)
                end
                if upgrade_type ~= UPGRADE_GET then
                    button_index = button_index + 1
                end
            
                table.remove(upgrades_available, upgrade_index)
            end
        -- if not, propose to get weapon TODO replace by get weapon from loot, or every 10 levels
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
                PlayerShip.upgrade_weapon(button.upgrade_type, button.upgrade_value)
            end
        end
    end

end

return upgrades