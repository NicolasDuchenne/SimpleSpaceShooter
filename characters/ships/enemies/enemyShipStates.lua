local STATES = {}
STATES.HIGH_SPEED_CHASE = "high_speed_chase"
STATES.FLEE = "flee"
STATES.MOVE = "move"
STATES.CHASE = "chase"
STATES.FIRE = "fire"
STATES.HARASS = "harass"


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
    if  math.vdist(ship.pos, PlayerShip.pos) < ship.avoid_ship_range then
        dir = dir + (PlayerShip.pos - ship.pos)
        ship_detected = true
    end

    if ship_detected == true then
        return dir.normalize()
    else
        return nil
    end
end

local get_random_harass_dir = function()
    return math.random(0, 1) == 0 and -1 or 1
end

local newEnemyShipStateMachine = function(ship)
    local stateMachine = {}
    stateMachine.shoot_timer = newTimer(ship.fire_delay_seconds)
    stateMachine.update_dir_timer = newTimer()
    stateMachine.harass_dir = get_random_harass_dir()
    stateMachine.state = STATES.HIGH_SPEED_CHASE

    local function move(dt, flee)
        flee = flee or false
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, PlayerShip.pos, ship.rad, ship.lerp_speed, dt)
        local harass_dir = ship.moving_dir.rotate(stateMachine.harass_dir  *math.pi/2)
        if flee == true then
            ship.moving_dir = -ship.moving_dir
        end
        if stateMachine.state == STATES.HARASS or stateMachine.state == STATES.FLEE then
            ship.moving_dir = ship.moving_dir+harass_dir
            ship.moving_dir.normalize()
        end
        local enemyShips_dir = get_close_ships_direction(ship)
        -- If close ships detected, move in opposite direction
        if enemyShips_dir then
            ship.moving_dir = -enemyShips_dir
        end
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end

    local function shoot(dt)
        if stateMachine.shoot_timer.update(dt) == true then
            ship.shoot()
            stateMachine.shoot_timer.start()
        end
    end

    local function update_harass_dir(dt)
        
        if stateMachine.update_dir_timer.update(dt) == true then
            stateMachine.harass_dir = get_random_harass_dir()
            stateMachine.update_dir_timer.start(math.random()+3)
            ship.harass_range = ship.base_harass_range + math.random(-50,50)
            ship.flee_range = ship.base_flee_range + math.random(-50,50)
        end
    end

    stateMachine.update = function(dt)

        update_harass_dir(dt)
        local dist_to_player = math.vdist(ship.pos, PlayerShip.pos)
        if stateMachine.state == STATES.HIGH_SPEED_CHASE then
            move(dt)
            ship.speed = ship.base_speed * 5
            if dist_to_player < ship.detection_range then
                ship.speed = ship.base_speed
                stateMachine.state = STATES.CHASE
            end
        elseif stateMachine.state == STATES.CHASE then
            move(dt)
            if dist_to_player < ship.shooting_range then
                stateMachine.state = STATES.FIRE
            elseif dist_to_player > ship.detection_range then
                stateMachine.state = STATES.HIGH_SPEED_CHASE
            end
        elseif stateMachine.state == STATES.FIRE then
            move(dt)
            shoot(dt)
            if dist_to_player > ship.shooting_range then
                ship.weapon.reset()
                stateMachine.state = STATES.CHASE
            elseif dist_to_player < ship.harass_range then
                stateMachine.state = STATES.HARASS
            end

        elseif stateMachine.state == STATES.HARASS then
            move(dt)
            shoot(dt)
            if dist_to_player > ship.harass_range then
                stateMachine.state = STATES.FIRE
            end
            if dist_to_player < ship.flee_range then
                stateMachine.state = STATES.FLEE
            end
        elseif stateMachine.state == STATES.FLEE then
            move(dt, true)
            shoot(dt)
            if dist_to_player > ship.harass_range then
                stateMachine.state = STATES.CHASE
            end
        end
        ship.constrain_ship_pos()
        
    end
    return stateMachine
end

return newEnemyShipStateMachine