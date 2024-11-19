function DeepCopy(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for key, value in pairs(original) do
            copy[key] = DeepCopy(value)
        end
    else
        copy = original -- If it's not a table, just copy the value
    end
    return copy
end