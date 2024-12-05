NAIRAN_BOSS = "nairan_boss"
local newBossShipStates = require("characters.ships.enemies.bossShipStates")

local boss_ship_params = {
    img = "assets/Void_EnemyFleet_2/Nairan/Designs - Base/PNGs/Nairan - Dreadnought - Base.png",
    engine = ENGINES.nairan.dreadnought,
    weapon = WEAPONS.nairan.boss.dreadnought_space_gun,
    destruction_animation = DESTRUCTION_ANIMATION.NAIRAN_BOSS,
    health = 100,
    hitbox_radius = 40,
    base_speed = 100,
    base_lerp_speed = 20,
    experience = 200,
    name = "Dreadnought",
    hit_player_damage = 20,
    health_per_level = 200,
    damage_per_level = 10
}


local function newBossShip(type, pos, rad)
    local ship = newShip(
        SHIP_GROUPS.ENEMY,
        boss_ship_params.img,
        boss_ship_params.engine,
        boss_ship_params.weapon,
        boss_ship_params.health,
        boss_ship_params.hitbox_radius,
        boss_ship_params.base_speed,
        boss_ship_params.base_lerp_speed,
        pos,
        rad,
        boss_ship_params.destruction_animation
    )
    ship.name = boss_ship_params.name
    ship.type = type
    ship.experience = boss_ship_params.experience * PlayerShip.experience.level
    ship.stateMachine = newBossShipStates(ship)
    ship.hit_player_timer = newTimer(1)
    ship.hit_player_damage = boss_ship_params.hit_player_damage
    ship.can_hit_player = true
    ship.life_bar_size = newVector2(600,30)
    ship.base_lerp_speed = boss_ship_params.base_lerp_speed
    ship.damage_per_level = boss_ship_params.damage_per_level
    ship.health_per_level = boss_ship_params.health_per_level

    ship.increase_max_health(ship.health_per_level * (PlayerShip.experience.level-1))
    ship.increase_damage(ship.damage_per_level * (PlayerShip.experience.level-1))

    ship.weapons = {}
    ship.weapons[WEAPONS.nairan.boss.dreadnought_space_gun] = newWeapon(WEAPONS.nairan.boss.dreadnought_space_gun, ship.group)
    ship.weapons[WEAPONS.nairan.boss.dreadnought_rockets] = newWeapon(WEAPONS.nairan.boss.dreadnought_rockets, ship.group)
    ship.weapons[WEAPONS.nairan.boss.rotating_dreadnought_space_gun] = newWeapon(WEAPONS.nairan.boss.rotating_dreadnought_space_gun, ship.group)

    table.insert(EnemyShips, ship)

    ship.die = function()
        ship.common_death_process()
        PlayerShip.experience.gain(ship.experience)
        Create_survivor_vortex()
    end

    ship.switch_weapon = function(key)
        ship.weapon = ship.weapons[key]
        -- launch all stats increase on new weapon
        ship.increase_damage(0)
        ship.increase_fire_rate(0)
        ship.increase_projectile_speed(0)
        ship.weapon.reset()
    end

    ship.hit_player = function(dt)
        if ship.hit_player_timer.update(dt) then
            ship.can_hit_player = true
        end
        if ship.can_hit_player == true then
            if  math.vdist(ship.pos, PlayerShip.pos) < PlayerShip.hitbox_radius+ship.hitbox_radius then
                ship.can_hit_player = false
                PlayerShip.hit(ship.hit_player_damage)
                ship.hit_player_timer.start()
            end
        end
        
    end

    ship.update = function(dt)
        if ship.is_dead == false then
            ship.engine.update(0, dt)
            ship.weapon.update(dt, ship.pos, ship.rad)
            ship.update_invincibility_timer(dt)
            ship.update_blink_timer(dt)
            ship.stateMachine.update(dt)
            ship.hit_player(dt)
        else
            ship.update_death_animation(dt)
        end
    end

    ship.draw_health = function()
        local text_boss_name = ship.name
        local boss_textWidth = Font:getWidth(text_boss_name)
        local boss_textHeight = Font:getHeight(text_boss_name)
        local boss_text_x_pos =  ScreenWidth*0.5 - boss_textWidth * 0.5
        local boss_text_y_pos = 5

        local x_pos = ScreenWidth*0.5-ship.life_bar_size.x*0.5
        local y_pos = boss_textHeight+10

        local text = tostring(ship.health).."/"..tostring(ship.max_health)
        local textWidth = Font:getWidth(text)
        local text_x_pos = ScreenWidth*0.5 - textWidth * 0.5
        local text_y_pos = y_pos +  5

        love.graphics.push()
        love.graphics.origin()
        love.graphics.setColor(1,0,0,0.6)
        love.graphics.rectangle("line", x_pos, y_pos, ship.life_bar_size.x, ship.life_bar_size.y)
        love.graphics.rectangle("fill", x_pos, y_pos, ship.life_bar_size.x*(ship.health/ship.max_health), ship.life_bar_size.y)
        love.graphics.setColor(1,1,1,1)
        love.graphics.print(text_boss_name, boss_text_x_pos, boss_text_y_pos)
        love.graphics.print(text, text_x_pos, text_y_pos)
        love.graphics.pop()
    end

    EnemyShips.total_exp = EnemyShips.total_exp + ship.experience
    
end

return newBossShip