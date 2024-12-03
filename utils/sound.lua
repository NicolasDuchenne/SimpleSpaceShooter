function PlaySound(sound, pitch_range)
    pitch_range = pitch_range or 0
    local newSoundInstance = sound:clone()
    local random_pitch = RandomFloat(1 - pitch_range, 1 + pitch_range)
    newSoundInstance:setPitch(random_pitch)
    newSoundInstance:play()
end

function PlayMusic(music_name)
    local music = love.audio.newSource(music_name, "stream")
    music:setLooping(true)
    music:play()
end
