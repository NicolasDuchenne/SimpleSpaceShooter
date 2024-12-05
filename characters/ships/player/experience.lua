Leveled_up = false
function newExperience()
    local max_level = 1000
    local exp_per_level = 100
    local level_new_weapon = 10
    local level_new_boss = 10
    local levels_exp = {
    }
    for i=0,max_level do
        levels_exp[i] = i*exp_per_level
    end

    local experience = {}
    experience.level = 0
    experience.exp = 0
    experience.total_exp = 0

    local function set_level_text()
        return "level: "..tostring(experience.level)
    end

    local function set_exp_text()
        return "exp: "..math.floor(experience.exp/levels_exp[experience.level] * 100).."%"
    end

    local function set_score_text()
        return "score: "..tostring(experience.total_exp)
    end



    experience.button_exp = newTextButton(
        newVector2(0,0),
        newVector2(100,20),
        set_exp_text()
    )

    experience.button_level = newTextButton(
        newVector2(0,20),
        newVector2(100,20),
        set_level_text()
    )

    experience.button_score = newTextButton(
        newVector2(ScreenWidth - 150,0),
        newVector2(150,40),
        set_score_text()
    )

    experience.level_up = function()
        experience.level = experience.level + 1
        experience.exp = 0
        experience.button_level.set_text(set_level_text())
        if experience.level == 1 or experience.level % level_new_weapon == 0 then
            PlayerShip.upgrades.create_weapon_choices()
        else
            PlayerShip.upgrades.create_choices()
        end
        if experience.level % level_new_boss == 0 then
            Create_boss_vortex()
        end
        Pause_game = true
    end

    experience.gain = function(exp)
        experience.exp = experience.exp  + exp
        experience.total_exp = experience.total_exp + exp
    end

    experience.update = function(dt)
        experience.button_exp.set_text(set_exp_text())
        experience.button_score.set_text(set_score_text())
        if experience.level < max_level and experience.exp >= levels_exp[experience.level] then
            experience.level_up()
        end
    end


    return experience
end
