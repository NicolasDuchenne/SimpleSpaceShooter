local function newState(name)
    local state = {}
    state.name = name
    state.offset = nil
    state.load = function()
    end
    state.update = function()
    end
    return state
end

    

local function newEnemyShipStateMachine(ship)
    local state_machine = {}
    state_machine.shoot_timer = newTimer(ship.fire_delay_seconds)
    state_machine.can_shoot = false
    state_machine.change_state_timer = newTimer(0.5)
    state_machine.can_change_state = true

    state_machine.dist_to_player = nil


    state_machine.change_state = function(new_state)
        if state_machine.can_change_state == true then
            state_machine.state = new_state
            state_machine.state.load()
            state_machine.can_change_state = false
            state_machine.change_state_timer.start()
        end
    end

    local function update_shoot_timer(dt)
        if state_machine.shoot_timer.update(dt) then
            state_machine.can_shoot = true
        end
    end

    local function shoot()
        if state_machine.can_shoot == true then
            state_machine.can_shoot = false
            ship.shoot()
            state_machine.shoot_timer.start()
        end
    end
    

    state_machine.high_speed_chase = newState("high_speed_chase")
    state_machine.high_speed_chase.load = function()
        ship.speed = PlayerShip.base_speed * 3
    end
    state_machine.high_speed_chase.update = function(dt)
        ship.move_and_look_at(PlayerShip.pos, dt)
        if state_machine.dist_to_player <ship.detection_range then
            state_machine.change_state(state_machine.chase)
        end
    end


    state_machine.chase = newState("chase")

    state_machine.chase.load = function()
        ship.speed = ship.base_speed
        if ship.harass_range == 0 then
            state_machine.chase.offset = 0
        else
            state_machine.chase.offset = (ship.pos - PlayerShip.pos).normalize().rotate(RandomFloat(math.pi*0.25, math.pi*075))*math.random(1.3 * ship.avoid_ship_range, 0.8 * ship.harass_range)

        end
        
    end
    
    state_machine.chase.update = function(dt)
        ship.move_to(PlayerShip.pos + state_machine.chase.offset, dt)
        ship.look_at(PlayerShip.pos, dt)
        shoot()
        if math.vdist(ship.pos, PlayerShip.pos) < ship.avoid_ship_range then
            state_machine.change_state(state_machine.avoid_ship)
        elseif state_machine.dist_to_player > ship.detection_range then
            if ship.harass_range == 0 then
                state_machine.change_state(state_machine.high_speed_chase)
            else
                state_machine.change_state(state_machine.get_around)
            end
        elseif math.vdist(ship.pos, PlayerShip.pos + state_machine.chase.offset) < 20 then
            state_machine.change_state(state_machine.chase)
        end
    end

    state_machine.get_around = newState("get_around")
    state_machine.get_around.load = function()
        ship.speed = PlayerShip.base_speed * 3
        state_machine.chase.offset = (ship.pos - PlayerShip.pos).normalize().rotate(RandomDirection()*RandomFloat(math.pi*0.5, math.pi*0.75)) * math.random(ship.harass_range, 0.8 * ship.detection_range)
    end
    
    state_machine.get_around.update = function(dt)
        ship.move_to(PlayerShip.pos + state_machine.chase.offset, dt)
        ship.look_at(PlayerShip.pos, dt)


        if math.vdist(ship.pos, PlayerShip.pos + state_machine.chase.offset) < 20 then
            state_machine.change_state(state_machine.chase)
        end
    end

    state_machine.avoid_ship = newState("avoid_ship")
    state_machine.avoid_ship.load = function()
        ship.speed = ship.base_speed * 1.5
        state_machine.chase.offset = (ship.pos - PlayerShip.pos).normalize().rotate(RandomDirection()*RandomFloat(-math.pi*0.25, math.pi*0.25)) * math.random(1.3*ship.avoid_ship_range, 0.8 * ship.harass_range)
    end
    
    state_machine.avoid_ship.update = function(dt)
        ship.move_to(PlayerShip.pos + state_machine.chase.offset, dt)
        ship.look_at(PlayerShip.pos, dt)
        shoot()
        if math.vdist(ship.pos, PlayerShip.pos + state_machine.chase.offset) < 20 then
            state_machine.change_state(state_machine.chase)
        end
    end

    state_machine.change_state(state_machine.high_speed_chase)

    state_machine.update = function(dt)
        if state_machine.change_state_timer.update(dt) then
            state_machine.can_change_state = true
        end
        state_machine.dist_to_player = math.vdist(ship.pos, PlayerShip.pos)
        update_shoot_timer(dt)
        state_machine.state.update(dt)
    end

    

    return state_machine

end
return newEnemyShipStateMachine