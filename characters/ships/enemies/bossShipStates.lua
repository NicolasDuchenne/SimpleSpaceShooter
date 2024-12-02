local function newBossShipStates(ship)
    local states = {}
    local list_start_states = {}
    local arrived_range = ship.base_sprite.width/2

    states.loop = 0

    states.shoot_timer = newTimer(0.5)
    states.horizontal_dir = newVector2(1,0)
    states.vertical_dir = newVector2(0,1)

    states.change_state = function(new_state)
        states.loop = 0
        states.state = new_state
        -- start timer to give time to boss to rotate
        states.shoot_timer.start()

    end


    local function shoot(dt)
        if states.shoot_timer.update(dt) == true then
            ship.shoot()
            states.shoot_timer.start()
        end
    end

    states.go_to_pos = function(dest_pos, dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, dest_pos, ship.rad, ship.lerp_speed, dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        ship.speed = ship.base_speed * 3
        
    end

    states.fire_in_dir = function(dir, dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, dir, ship.rad, ship.lerp_speed, dt)
        if ship.touched_width_limit == true then
            states.horizontal_dir = -states.horizontal_dir
            states.loop = states.loop + 1
        end
        ship.moving_dir = states.horizontal_dir
        ship.speed = ship.base_speed * 3
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
        shoot(dt)
    end


    states.idle = function(dt)
        local state_choice = math.random(1, #list_start_states)
        states.change_state(list_start_states[state_choice])
    end

    states.start_fire_down = function(dt)
        local up_left_pos = newVector2(arrived_range, arrived_range)
        states.go_to_pos(up_left_pos, dt)
        if math.vdist(ship.pos, up_left_pos) < arrived_range then
            states.change_state(states.fire_down)
        end
    end
    
    states.fire_down = function(dt)
        ship.weapon = ship.weapons[WEAPONS.nairan.boss.dreadnought_space_gun]
        states.fire_in_dir(newVector2(ship.pos.x, ScaledScreenHeight), dt)
        if states.loop > 1 then
            states.change_state(states.idle)
        end
    end

    states.start_fire_up = function(dt)
        local down_left_pos = newVector2(arrived_range, ScaledScreenHeight-arrived_range)
        states.go_to_pos(down_left_pos, dt)
        if math.vdist(ship.pos, down_left_pos) < arrived_range then
            states.change_state(states.fire_up)
        end
    end
    
    states.fire_up = function(dt)
        ship.weapon = ship.weapons[WEAPONS.nairan.boss.dreadnought_rockets]
        states.fire_in_dir(newVector2(ship.pos.x, 0), dt)
        if states.loop > 1 then
            states.change_state(states.idle)
        end
    end

    states.chase = function(dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, PlayerShip.pos, ship.rad, ship.lerp_speed, dt)
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end

    states.state = states.idle

    table.insert(list_start_states, states.start_fire_down)
    table.insert(list_start_states, states.start_fire_up)

    states.update = function(dt)
        states.state(dt)
        ship.constrain_ship_pos()
    end
    return states
end
return newBossShipStates