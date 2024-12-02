
-- Function to manually unpack a table, created because table.unpack does not seem to work
local function manualUnpack(t, i, j)
    i, j = i or 1, j or #t
    if i > j then return end
    return t[i], manualUnpack(t, i + 1, j)
end

function CreateCallback(func, ...)
    local args = {...} -- Capture the arguments in a table
    return function()
        func(manualUnpack(args)) -- Pass the arguments to the function
    end
end
