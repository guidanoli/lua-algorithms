local Select = require "select"
local RandomTable = require "rtable"

local t = {}

function t:maximum()
    local nan = 0/0
    assert(Select:maximum{} == nil)
    assert(Select:maximum{1} == 1)
    assert(Select:maximum{1, 2} == 2)
    assert(Select:maximum{1, 0} == 1)
    assert(Select:maximum{nan} == nil)
    assert(Select:maximum{nan, nan} == nil)
    assert(Select:maximum{1, nan} == 1)
    assert(Select:maximum{nan, 1} == 1)
    assert(Select:maximum{1, nan, 0} == 1)
    assert(Select:maximum{1, nan, 2} == 2)
end

function t:minimum()
    local nan = 0/0
    assert(Select:minimum{} == nil)
    assert(Select:minimum{1} == 1)
    assert(Select:minimum{1, 2} == 1)
    assert(Select:minimum{1, 0} == 0)
    assert(Select:minimum{nan} == nil)
    assert(Select:minimum{nan, nan} == nil)
    assert(Select:minimum{1, nan} == 1)
    assert(Select:minimum{nan, 1} == 1)
    assert(Select:minimum{1, nan, 0} == 0)
    assert(Select:minimum{1, nan, 2} == 1)
end

function t:partition()
    for i = 1, 1000 do
        local t = RandomTable(100, 100)
        local r = math.random(#t)
        local p = math.random(r)
        local q = math.ceil((p + r) / 2)
        Select:partition(t, p, q, r)
    end
end

function t:randomizedPartition()
    for i = 1, 1000 do
        local t = RandomTable(100, 100)
        local r = math.random(#t)
        local p = math.random(r)
        Select:randomizedPartition(t, p, r)
    end
end

return t
