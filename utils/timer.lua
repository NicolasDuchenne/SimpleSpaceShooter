function newTimer(duration, autostart)
    local timer = {}
    timer.duration = duration or 1
    timer.elapsed_time = 0
    timer.started = true
    if autostart~=nil then
        if autostart == false then
            timer.started = false
        end
    end

    timer.set_duration = function(duration)
        timer.duration = duration
    end

    timer.update = function(dt)
        if timer.started == true then
            timer.elapsed_time = timer.elapsed_time + dt
            if timer.elapsed_time > timer.duration then
                timer.stop()
                return true
            end
        end
        return false
    end

    timer.start = function(new_duration)
        timer.duration = new_duration or timer.duration
        timer.started = true
        timer.elapsed_time = 0
    end

    timer.stop = function()
        timer.started = false
        timer.elapsed_time = 0
    end
        
    return timer

end