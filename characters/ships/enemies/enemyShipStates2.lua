local function newEnemyShipStateMachine(ship)
    local state = {}
    state.shoot_timer = newTimer(ship.fire_delay_seconds)
    state.can_shoot = true

    local function update_shoot_timer(dt)
        if state.shoot_timer.update(dt) then
            state.can_shoot = true
        end
    end

    local function shoot()
        if state.can_shoot == true then
            state.can_shoot = false
            ship.shoot()
            state.shoot_timer.start()
        end
    end
    

    state.high_speed_chase = function(dt)
        ship.move_toward(PlayerShip.pos, dt)
        shoot()
    end

    state.state = state.high_speed_chase

    state.update = function(dt)
        update_shoot_timer(dt)
        state.state(dt)
    end
    return state

end
return newEnemyShipStateMachine