local STATES = {}
STATES.HIGH_SPEED_CHASE = "high_speed_chase"
STATES.FLEE = "flee"
STATES.MOVE = "move"
STATES.CHASE = "chase"
STATES.FIRE = "fire"
STATES.HARASS = "harass"
STATES.GET_AROUND = "get_around"


local function get_close_ships_direction(ship)
    local dir = newVector2()
    local ship_detected = false

    -- Check if enemy ships too close
    for i, enemyShip in ipairs(EnemyShips) do
        if enemyShip ~= ship and  math.vdist(ship.pos, enemyShip.pos) < ship.avoid_ship_range then
            -- random vector makes movement seem more natural, and make ship move when they overlap perfectly
            dir = dir + (enemyShip.pos - ship.pos) + newVector2(math.random(0,1), math.random(0,1))*0.2 
            
            ship_detected = true
        end
    end

    -- Check if player is too close
    if ship.self_destruct == false then
        if  math.vdist(ship.pos, PlayerShip.pos) < ship.avoid_ship_range then
            dir = dir + (PlayerShip.pos - ship.pos)
            ship_detected = true
        end
    end

    if ship_detected == true then
        local close_ship_dir = dir.normalize()
        return close_ship_dir
    else
        return nil
    end
end

local get_random_harass_dir = function()
    return math.random(0, 1) == 0 and -1 or 1
end

local newEnemyShipStateMachine = function(ship)
    local stateMachine = {}
    stateMachine.canChangeState = true
    stateMachine.can_shoot = true
    stateMachine.change_state_timer = newTimer(0.5)
    stateMachine.shoot_timer = newTimer(ship.fire_delay_seconds)
    stateMachine.update_dir_timer = newTimer()
    stateMachine.harass_dir = get_random_harass_dir()
    stateMachine.state = STATES.HIGH_SPEED_CHASE
    stateMachine.enemyShips_dir = nil
    --stateMachine.get_around = false


    local function move(dt, flee)
        flee = flee or false
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, PlayerShip.pos, ship.rad, ship.lerp_speed, dt)
        local harass_dir = ship.moving_dir.rotate(stateMachine.harass_dir*math.pi/2)
        if flee == true then
            ship.moving_dir = -ship.moving_dir
        end
        
        if stateMachine.state == STATES.HARASS or stateMachine.state == STATES.FLEE then
            ship.moving_dir = ship.moving_dir+harass_dir * 3
        elseif  stateMachine.state == STATES.GET_AROUND then
            ship.moving_dir = ship.moving_dir+harass_dir * 2
        end
        ship.moving_dir = ship.moving_dir.normalize()
        if stateMachine.state == STATES.CHASE or stateMachine.state == STATES.FIRE then
            stateMachine.enemyShips_dir = get_close_ships_direction(ship)
            -- If close ships detected, move in opposite direction
            if stateMachine.enemyShips_dir then
                ship.moving_dir = -stateMachine.enemyShips_dir
            end
        end
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end

    local function shoot(dt)
        if stateMachine.shoot_timer.update(dt) then
            stateMachine.can_shoot = true
        end
        if stateMachine.can_shoot == true then
            stateMachine.can_shoot = false
            ship.shoot()
            stateMachine.shoot_timer.start()
        end
    end

    local function update_harass_dir(dt)
        
        if stateMachine.update_dir_timer.update(dt) == true then
            stateMachine.harass_dir = get_random_harass_dir()
            local new_timer_duration = 0.5 + math.random()*4
            stateMachine.update_dir_timer.start(new_timer_duration)
            ship.harass_range = ship.base_harass_range + math.random(-50,50)
            ship.flee_range = ship.base_flee_range + math.random(-50,50)
            --stateMachine.get_around = true
        end
    end

    local function change_state(newState)
        if stateMachine.canChangeState == true then
            ship.speed = ship.base_speed
            stateMachine.canChangeState = false
            stateMachine.change_state_timer.start(0.25 + math.random()*0.5)
            stateMachine.state = newState
        end
    end

    stateMachine.update = function(dt)
        if stateMachine.change_state_timer.update(dt) then
            stateMachine.canChangeState = true
        end

        update_harass_dir(dt)
        local dist_to_player = math.vdist(ship.pos, PlayerShip.pos)
        -- if stateMachine.get_around == true then
        --     stateMachine.get_around = false
        --     if math.random(2) == 1 then
        --         change_state(STATES.GET_AROUND)
        --     end
        -- end
        if stateMachine.state == STATES.HIGH_SPEED_CHASE then
            move(dt)
            ship.speed = ship.base_speed * 5
            if dist_to_player < ship.detection_range then
                change_state(STATES.CHASE)
            end
        elseif stateMachine.state == STATES.GET_AROUND then
            move(dt)
            ship.speed = ship.base_speed * 3
            if dist_to_player < ship.detection_range then
                change_state(STATES.CHASE)
            end
        elseif stateMachine.state == STATES.CHASE then
            move(dt)
            if dist_to_player < ship.shooting_range then
                change_state(STATES.FIRE)
            elseif dist_to_player > ship.detection_range then
                change_state(STATES.GET_AROUND)
            end
        elseif stateMachine.state == STATES.FIRE then
            move(dt)
            shoot(dt)
            if dist_to_player > ship.shooting_range then
                ship.weapon.reset()
                change_state(STATES.CHASE)
            elseif dist_to_player < ship.harass_range then
                change_state(STATES.HARASS)
            end

        elseif stateMachine.state == STATES.HARASS then
            move(dt)
            shoot(dt)
            if dist_to_player > ship.harass_range then
                change_state(STATES.FIRE)
            end
            if dist_to_player < ship.flee_range then
                change_state(STATES.FLEE)
            end
        elseif stateMachine.state == STATES.FLEE then
            move(dt, true)
            shoot(dt)
            if dist_to_player > ship.harass_range then
                change_state(STATES.CHASE)
            end
        end
        ship.constrain_ship_pos()
        
    end
    return stateMachine
end

return newEnemyShipStateMachine