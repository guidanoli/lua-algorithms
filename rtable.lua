-- Random table

local RandomTable = {}

function RandomTable:new(n, max)
    local t = {}
    for i = 1, n do
        t[i] = math.random(max)
    end
    return t
end

-----------------------
-- Return module
-----------------------

return RandomTable
