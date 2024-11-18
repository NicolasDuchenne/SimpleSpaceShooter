function deep_copy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deep_copy(value) -- Recursive call for nested tables
        else
            copy[key] = value
        end
    end
    return copy
end