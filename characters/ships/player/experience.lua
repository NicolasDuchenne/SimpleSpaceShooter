Leveled_up = false
local max_level = 1000
local exp_per_level = 100
local level_new_weapon = 10
local levels_exp = {
}
for i=0,max_level do
    levels_exp[i] = i*exp_per_level
end

local experience = {}
experience.level = 0
experience.exp = 0

local function set_level_text()
    return "level: "..tostring(experience.level)
end

local function set_exp_text()
    return "exp: "..math.floor(experience.exp/levels_exp[experience.level] * 100).."%"
end

experience.button_level = newTextButton(
    newVector2(0,20),
    newVector2(50,20),
    set_level_text()
)

experience.button_exp = newTextButton(
    newVector2(0,0),
    newVector2(50,20),
    set_exp_text()
)




experience.level_up = function()
    experience.level = experience.level + 1
    experience.exp = 0
    experience.button_level.set_text(set_level_text())
    if experience.level % level_new_weapon == 1 then
        PlayerShip.upgrades.create_weapon_choices()
    else
        PlayerShip.upgrades.create_choices()
    end
    Pause_game = true
end

experience.gain = function(exp)
    experience.exp = experience.exp  + exp
end

experience.update = function(dt)
    experience.button_exp.set_text(set_exp_text())
    if experience.level < max_level and experience.exp >= levels_exp[experience.level] then
        experience.level_up()
    end
end


return experience
