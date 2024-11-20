local STATES = {}
STATES.IDLE = "idle"
STATES.CHASE = "chase"
STATES.FLEE = "flee"
STATES.FIRE = "fire"

local enemy_detection_range = 100

local function get_close_ships_direction(ship)
    local dir = newVector2()
    local ship_detected = false
    for i, enemyShip in ipairs(EnemyShips) do
        if enemyShip ~= ship and  math.vdist(ship.pos, enemyShip.pos) < enemy_detection_range then
            dir = dir + (enemyShip.pos - ship.pos)
            ship_detected = true
        end
    end
    if ship_detected == true then
        return dir.normalize()
    else
        return nil
    end
end


local newEnemyShipStateMachine  = function()
    local stateMachine = {}
    stateMachine.state = STATES.IDLE
    local function move(ship, dt)
        ship.rad, ship.moving_dir = SmoothLookAt(ship.pos, PlayerShip.pos, ship.rad, ship.lerp_speed, dt)
        local enemyShips_dir = get_close_ships_direction(ship)
        if enemyShips_dir then
            ship.moving_dir = -enemyShips_dir
        end
        ship.pos = ship.pos + ship.moving_dir * ship.speed * dt
    end
    local function shoot(ship, dt)
        move(ship, dt)
        
        ship.shoot()
    end
    stateMachine.update = function(ship, dt)
        local dist_to_player = math.vdist(ship.pos, PlayerShip.pos)
        if stateMachine.state == STATES.IDLE then
            if dist_to_player < ship.detection_range then
                stateMachine.state = STATES.CHASE
            end
        elseif stateMachine.state == STATES.CHASE then
            move(ship, dt)
            if dist_to_player < ship.shooting_range then
                stateMachine.state = STATES.FIRE
            elseif dist_to_player > ship.detection_range then
                stateMachine.state = STATES.IDLE
            end
        elseif stateMachine.state == STATES.FIRE then
            shoot(ship, dt)
            if dist_to_player > ship.shooting_range then
                stateMachine.state = STATES.CHASE
            end
        end
        
    end
    return stateMachine
end

return newEnemyShipStateMachine