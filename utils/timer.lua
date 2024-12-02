function newTimer(duration, autostart)
    local timer = {}
    autostart = autostart or true

    timer.duration = duration or 1
    timer.elapsed_time = 0
    if autostart == true then
        timer.started = true
    else
        timer.started = false
    end

    timer.set_duration = function(duration)
        timer.duration = duration
    end

    timer.update = function(dt)
        if timer.started == true then
            timer.elapsed_time = timer.elapsed_time + dt
            if timer.elapsed_time > timer.duration then
                timer.elapsed_time = 0
                timer.started = false
                return true
            end
        end
        return false
    end

    timer.start = function(duration)
        timer.duration = duration or timer.duration
        timer.started = true
        timer.elapsed_time = 0
    end
        
    return timer

end