function PlaySound(sound, pitch_range, volume)
    pitch_range = pitch_range or 0
    volume = volume or 1
    local newSoundInstance = sound:clone()
    local random_pitch = RandomFloat(1 - pitch_range, 1 + pitch_range)
    newSoundInstance:setPitch(random_pitch)
    newSoundInstance:setVolume(math.clamp(volume,0,1))
    newSoundInstance:play()
end

function PlayMusic(music_name)
    local music = love.audio.newSource(music_name, "stream")
    music:setLooping(true)
    music:play()
    return music
end
