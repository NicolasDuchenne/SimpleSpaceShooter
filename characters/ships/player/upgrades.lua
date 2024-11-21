UPGRADES = {}
UPGRADES.auto_cannon = {}
UPGRADES.auto_cannon.speed = "auto_cannon_speed_upgrade"
UPGRADES.auto_cannon.damage = "auto_cannon_damage_upgrade"
UPGRADES.big_space_gun = {}
UPGRADES.big_space_gun.receive = "big_space_gun_receive_upgrade"
UPGRADES.big_space_gun.speed = "big_space_gun_speed_upgrade"
UPGRADES.big_space_gun.damage = "big_space_gun_damage_upgrade"
local upgrades_list = {}



upgrades_list[UPGRADES.auto_cannon.speed] = {
    pickup_type = PICKUPS.auto_cannon,
    color = {r=0, g=1, b=0},
    increase_percentage = 20
}

upgrades_list[UPGRADES.auto_cannon.damage] = {
    pickup_type = PICKUPS.auto_cannon,
    color = {r=1, g=0, b=0},
    increase_damage = 1
}

upgrades_list[UPGRADES.big_space_gun.receive] = {
    pickup_type = PICKUPS.big_space_gun,
    color = {r=1, g=1, b=1}
}

upgrades_list[UPGRADES.big_space_gun.speed] = {
    pickup_type = PICKUPS.big_space_gun,
    color = {r=0, g=1, b=0},
    increase_percentage = 10
}

upgrades_list[UPGRADES.big_space_gun.damage] = {
    pickup_type = PICKUPS.big_space_gun,
    color = {r=1, g=0, b=0},
    increase_damage = 2
}

local function newUpgrade(type)
    local upgrade = upgrades_list[type]
    upgrade.pickup = newPickup(upgrade.pickup_type)
    return upgrade
end

local upgrades = {}
upgrades.number_of_choice = 3
upgrades.buttons = {}
upgrades.size = newVector2(64,64)

upgrades.create_choices = function()
    local offset = 0
    local i = 1
    for label, type in pairs(UPGRADES.auto_cannon) do
        local upgrade = newUpgrade(type)
        local quadSPrite = upgrade.pickup.sprite
        print(upgrade.color.r)
        quadSPrite.color = upgrade.color
        upgrades.buttons[i] = newQuadButton(
            newVector2(ScreenWidth/2 + offset, ScreenHeight/2),
            quadSPrite,
            label,
            newVector2(0,-20),
            upgrades.size
        )
        offset = offset + upgrades.buttons[i].size.x
        i = i + 1
    end
end

upgrades.delete_choices = function()
    for i=1, #upgrades.buttons do
        upgrades.buttons[i].remove = true
    end
    upgrades.buttons = {}
end

return upgrades