BASE_ENGINE = "base"
BURST_ENGINE = "burst"

local engine = {}
engine.type = "base"

engine.base_sprites = {}
engine.base_sprites[BASE_ENGINE] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Base Engine.png")
engine.base_sprites[BURST_ENGINE] = newSprite("assets/Void_MainShip/Main Ship/Main Ship - Engines/PNGs/Main Ship - Engines - Burst Engine.png")


local function create_engine_effect(params)
    local engine_effects =  {
        idle = newQuadSprite(params.img.."Idle.png", params.idle_cquad, params.lquad, params.wquad, params.hquad, params.fps),
        powering = newQuadSprite(params.img.."Powering.png", params.powering_cquad, params.lquad, params.wquad, params.hquad, params.fps),
    }
    return engine_effects
end

local engine_effects_params = {}
engine_effects_params[BASE_ENGINE] = {img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Base Engine - " ,idle_cquad = 3, powering_cquad = 4, lquad = 1, wquad = 48, hquad = 48, fps = 8}
engine_effects_params[BURST_ENGINE] = {img = "assets/Void_MainShip/Main Ship/Main Ship - Engine Effects/PNGs/Main Ship - Engines - Burst Engine - " ,idle_cquad = 4, powering_cquad = 4, lquad = 1, wquad = 48, hquad = 48, fps = 8}

engine.list_engine_effects = {}
engine.list_engine_effects[BASE_ENGINE] = create_engine_effect(engine_effects_params[BASE_ENGINE])
engine.list_engine_effects[BURST_ENGINE] = create_engine_effect(engine_effects_params[BURST_ENGINE])


engine.base_sprite = engine.base_sprites[engine.type]
engine.engine_effects = engine.list_engine_effects[engine.type]
engine.engine_effect = nil

engine.set_type = function(type)
    engine.type = type
    engine.base_sprite = engine.base_sprites[engine.type]
    engine.engine_effects = engine.list_engine_effects[engine.type]
end

engine.update = function(speed, dt)
        -- Manage engine effect


        if speed>0 then
            engine.engine_effect = engine.engine_effects.powering
        else
            engine.engine_effect = engine.engine_effects.idle
        end
    
        engine.engine_effect.update(dt)
end

engine.draw = function(pos, rad)
    engine.base_sprite.draw(pos, rad)
    engine.engine_effect.draw(pos, rad)
end

return engine
