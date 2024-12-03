UPGRADE_GET = "get"
UPGRADE_SHOOTING_SPEED = "shooting_speed"
UPGRADE_DAMAGE = "damage"
UPGRADE_PROJECTILE_SPEED = "projectile_speed"
UPGRADE_HEAL = "heal"
UPGRADE_MAX_BOOST = "max_boost"

local weapon_upgrade_list = {
    get =  {
        color = newColor(255, 255, 255)
    }
}

local upgrades_list = {
    shooting_speed = {
        pickup = nil,
        color = newColor(0, 255, 0),
        increase = 20,
        max = 300
    },
    damage = {
        pickup = nil,
        color = newColor(255, 0, 0),
        increase = 10,
        max = 200
    },
    projectile_speed = {
        pickup = nil,
        color = newColor(0, 0, 255),
        increase = 30,
        max = 400
    },
    heal = {
        pickup = PICKUP.health,
        color = newColor(255, 255, 255),
        increase = 10
    },
    max_boost = {
        pickup = PICKUP.boost,
        color = newColor(255, 255, 255),
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
bupgrades_available[4] = UPGRADE_HEAL
bupgrades_available[5] = UPGRADE_MAX_BOOST


local function upgrade_weapon_callback(upgrade_type, upgrade_value)
    Pause_game = false
    PlayerShip.upgrades.delete_choices()
    PlayerShip.upgrade_weapon(upgrade_type, upgrade_value)
end



local function get_weapon_callback(weapon_type)
    Pause_game = false
    PlayerShip.upgrades.delete_choices()
    PlayerShip.inventory.add_weapon(weapon_type)
end


function newUpgrades()
    local upgrades = {}
    upgrades.number_of_choice = 3
    upgrades.number_of_weapon_choice = 2
    upgrades.buttons = {}
    upgrades.size = newVector2(128,128)
    upgrades.img_scale = newVector2(2,2)

    local function upgrade_attenuation_function(max_increase, current_increase, base_increase)
        return math.floor((max_increase - current_increase)/max_increase * base_increase)
    end

    local function create_upgrade_button(
            upgrade_type,
            weapon_type,
            button_index,
            number_of_choice,
            offset,
            color,
            callback,
            text
        )
        
        local pickup = newPickup(weapon_type)
        local quadSPrite = pickup.sprite

        quadSPrite.color = color
        upgrades.buttons[button_index] = newQuadButton(
            newVector2(ScreenWidth/2  + offset - upgrades.size.x * number_of_choice / 2, ScreenHeight/2 + upgrades.size.y),
            quadSPrite,
            upgrade_type.."\n"..(text or ""),
            newVector2(0,0),
            upgrades.size,
            upgrades.img_scale,
            callback
        )

        offset = offset + upgrades.buttons[button_index].size.x
        return offset
    end

    upgrades.create_weapon_choices = function()
        
        if PlayerShip.inventory.weapons_full == false then
            local offset = 0
            local button_index = 1
            local weapons = DeepCopy(bweapons)
            local number_of_choice_created = 0
            
            
            while #weapons > 0 and number_of_choice_created < upgrades.number_of_weapon_choice do
                local weapon_index = math.random(1, #weapons)
                local weapon_type = weapons[weapon_index]
                local upgrade_type = UPGRADE_GET
                local color = weapon_upgrade_list[upgrade_type].color
                
                if not PlayerShip.inventory.has_weapon(weapon_type) then
                    offset = create_upgrade_button(
                        upgrade_type,
                        weapon_type,
                        button_index,
                        upgrades.number_of_weapon_choice, 
                        offset,
                        color,
                        CreateCallback(get_weapon_callback, weapon_type)
                    )
                    button_index = button_index + 1
                    number_of_choice_created = number_of_choice_created +1
                end
                table.remove(weapons, weapon_index)
                
            end
        else
            upgrades.create_choices()
        end
    end

    local function get_current_increase(upgrade_type)
        if upgrade_type == UPGRADE_SHOOTING_SPEED then
            return PlayerShip.shooting_speed_increase
        elseif  upgrade_type == UPGRADE_DAMAGE then
            return PlayerShip.bullet_damage_increase
        elseif upgrade_type == UPGRADE_PROJECTILE_SPEED then
            return PlayerShip.bullet_speed_increase
        elseif upgrade_type == UPGRADE_HEAL then
            return PlayerShip.health_increase
        elseif upgrade_type == UPGRADE_MAX_BOOST then
            return PlayerShip.boost_increase
        end
        return nil
    end


    upgrades.create_choices = function()
        local offset = 0
        local button_index = 1
        local number_of_choice_created = 0
        local upgrades_available = DeepCopy(bupgrades_available)
        
        while number_of_choice_created < upgrades.number_of_choice do
            if #upgrades_available > 0 then
                local upgrade_index = math.random(1, #upgrades_available)
                local upgrade_type = upgrades_available[upgrade_index]
                local upgrade_value = upgrades_list[upgrade_type].increase
                local max_upgrade_increase = upgrades_list[upgrade_type].max
                local color = upgrades_list[upgrade_type].color
                local weapon_type = PlayerShip.weapon.type
                if upgrades_list[upgrade_type].pickup then
                    weapon_type =  upgrades_list[upgrade_type].pickup
                end
                local current_increase = get_current_increase(upgrade_type)
                local text = ""

                if current_increase then
                    if max_upgrade_increase then
                        upgrade_value = upgrade_attenuation_function(max_upgrade_increase, current_increase, upgrade_value)
                    end
                    text = "current: "..current_increase.." \nincrease : "..upgrade_value
                end
                
                if upgrade_type then
                    offset = create_upgrade_button(
                        upgrade_type,
                        weapon_type,
                        button_index,
                        upgrades.number_of_choice,
                        offset,
                        color,
                        CreateCallback(upgrade_weapon_callback, upgrade_type, upgrade_value),
                        text
                    )
                    button_index = button_index + 1
                end
            
                table.remove(upgrades_available, upgrade_index)
                number_of_choice_created = number_of_choice_created +1
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
    end

    return upgrades
end