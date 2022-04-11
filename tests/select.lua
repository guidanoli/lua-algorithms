local Select = require "select"

local t = {}

function t:failing()
    assert(false)
end

function t:passing()
end

return t
