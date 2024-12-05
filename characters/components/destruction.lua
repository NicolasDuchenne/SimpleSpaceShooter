
DESTRUCTION_ANIMATION = {}
DESTRUCTION_ANIMATION.NAIRAN_FIGHTER = "destruction_nairan_fighter"
DESTRUCTION_ANIMATION.NAIRAN_TORPEDO = "destruction_nairan_torpedo"
DESTRUCTION_ANIMATION.NAIRAN_BATTLECRUISER = "destruction_nairan_battlecruiser"
DESTRUCTION_ANIMATION.NAIRAN_BOSS = "destruction_nairan_boss"

local destruction_sprite_params = {}
destruction_sprite_params[DESTRUCTION_ANIMATION.NAIRAN_FIGHTER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Destruction/PNGs/Nairan - Fighter -  Destruction.png",
    cquad = 18,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    fps = 24
}

destruction_sprite_params[DESTRUCTION_ANIMATION.NAIRAN_TORPEDO] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Destruction/PNGs/Nairan - Torpedo Ship -  Destruction.png",
    cquad = 16,
    lquad = 1,
    wquad = 64,
    hquad = 64,
    fps = 24
}

destruction_sprite_params[DESTRUCTION_ANIMATION.NAIRAN_BATTLECRUISER] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Destruction/PNGs/Nairan - Battlecruiser  -  Destruction.png",
    cquad = 18,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    fps = 24
}

destruction_sprite_params[DESTRUCTION_ANIMATION.NAIRAN_BOSS] = {
    img = "assets/Void_EnemyFleet_2/Nairan/Destruction/PNGs/Nairan - Dreadnought -  Destruction.png",
    cquad = 18,
    lquad = 1,
    wquad = 128,
    hquad = 128,
    fps = 24
}


function newDestructionAnimation(type)
    local destruction_animation = {}
    destruction_animation.img = newQuadSprite(
        destruction_sprite_params[type].img,
        destruction_sprite_params[type].cquad,
        destruction_sprite_params[type].lquad,
        destruction_sprite_params[type].wquad,
        destruction_sprite_params[type].hquad,
        destruction_sprite_params[type].fps,
        nil,
        SPRITE_PLAY_ONCE
    )

    destruction_animation.update = function(dt)
        destruction_animation.img.update(dt)
    end

    destruction_animation.draw = function(pos, rad)
        destruction_animation.img.draw(pos, rad)
    end

    return destruction_animation
end