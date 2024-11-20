
-- did not work when returning two list from require, ask why
local engines_config= require("characters.components.engines_config")
local base_sprites = engines_config.base
local engine_effects_params = engines_config.effects

local function create_engine_effect(params)
    local output = {}
    if params.always_powering and params.always_powering == true then
        output = newQuadSprite(params.img, params.idle_cquad, params.lquad, params.wquad, params.hquad, params.fps)
    else
        output =  {
            idle = newQuadSprite(params.img.."Idle.png", params.idle_cquad, params.lquad, params.wquad, params.hquad, params.fps),
            powering = newQuadSprite(params.img.."Powering.png", params.powering_cquad, params.lquad, params.wquad, params.hquad, params.fps),
        }
    end
    return output
end



function newEngine(type)
    local engine = {}
    engine.change_type = function(type)
        if type ~= engine.type then
            engine.type = type
            engine.current_base_sprite = base_sprites[engine.type]
            engine.current_engine_effects = create_engine_effect(engine_effects_params[engine.type])
        end
    end
    engine.change_type(type)
    engine.always_powering = engine_effects_params[engine.type].always_powering
    engine.current_engine_effect = nil

    

    engine.update = function(speed, dt)
            -- Manage engine effect
            if engine.always_powering == true then
                engine.current_engine_effect = engine.current_engine_effects
            else
                if speed>0 then
                    engine.current_engine_effect = engine.current_engine_effects.powering
                else
                    engine.current_engine_effect = engine.current_engine_effects.idle
                end
            end
        
            engine.current_engine_effect.update(dt)
    end
 
    engine.draw = function(pos, rad)
        if engine.current_base_sprite then
            engine.current_base_sprite.draw(pos, rad)
        end
        engine.current_engine_effect.draw(pos, rad)
    end

    return engine
end
