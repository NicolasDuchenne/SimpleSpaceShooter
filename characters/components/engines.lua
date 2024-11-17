BASE_ENGINE = "base"
BURST_ENGINE = "burst"

local base_sprites = {}
local engine_effects_params = {}

base_sprites[BASE_ENGINE] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Base Engine.png")
engine_effects_params[BASE_ENGINE] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Base Engine - " ,
    idle_cquad = 3,
    powering_cquad = 4,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 8
}

base_sprites[BURST_ENGINE] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Burst Engine.png")
engine_effects_params[BURST_ENGINE] = {
    img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Burst Engine - " ,
    idle_cquad = 4,
    powering_cquad = 4,
    lquad = 1,
    wquad = 48,
    hquad = 48,
    fps = 8
}


local function create_engine_effect(params)
    local output =  {
        idle = newQuadSprite(params.img.."Idle.png", params.idle_cquad, params.lquad, params.wquad, params.hquad, params.fps),
        powering = newQuadSprite(params.img.."Powering.png", params.powering_cquad, params.lquad, params.wquad, params.hquad, params.fps),
    }
    return output
end

local engine_effects = {}
for type, params in pairs(engine_effects_params) do
    engine_effects[type] = create_engine_effect(params)
end




function newEngine(type)
    local engine = {}
    engine.type = type


    engine.current_base_sprite = base_sprites[engine.type]
    engine.current_engine_effects = engine_effects[engine.type]
    engine.current_engine_effect = nil

    engine.set_type = function(type)
        engine.type = type
        engine.current_base_sprite = base_sprites[engine.type]
        engine.current_engine_effects = engine_effects[engine.type]
    end

    engine.update = function(speed, dt)
            -- Manage engine effect
            if speed>0 then
                engine.current_engine_effect = engine.current_engine_effects.powering
            else
                engine.current_engine_effect = engine.current_engine_effects.idle
            end
        
            engine.current_engine_effect.update(dt)
    end

    engine.draw = function(pos, rad)
        engine.current_base_sprite.draw(pos, rad)
        engine.current_engine_effect.draw(pos, rad)
    end

    return engine
end
