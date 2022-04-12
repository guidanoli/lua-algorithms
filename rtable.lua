-- Random table

-----------------------
-- Define module
-----------------------

local RandomTable = {}

-----------------------
-- Public functions
-----------------------

function RandomTable:new(n, max)
    local t = {}
    for i = 1, n do
        t[i] = math.random(max)
    end
    return t
end

-----------------------
-- Private functions
-----------------------

-----------------------
-- Return module
-----------------------

return RandomTable
