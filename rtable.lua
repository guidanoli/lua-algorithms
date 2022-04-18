-- Random table

local Class = require "class"

-----------------------
-- Define class
-----------------------

local RandomTable = Class{name = "RandomTable"}

-----------------------
-- Public functions
-----------------------

function RandomTable:init(n, max)
    for i = 1, n do
        self[i] = math.random(max)
    end
end

-----------------------
-- Return class
-----------------------

return RandomTable
