local select = require "select"
local rtable = require "rtable"

local t = {}

function t:maximum()
    local nan = 0/0
    assert(select:maximum{} == nil)
    assert(select:maximum{1} == 1)
    assert(select:maximum{1, 2} == 2)
    assert(select:maximum{1, 0} == 1)
    assert(select:maximum{nan} == nil)
    assert(select:maximum{nan, nan} == nil)
    assert(select:maximum{1, nan} == 1)
    assert(select:maximum{nan, 1} == 1)
    assert(select:maximum{1, nan, 0} == 1)
    assert(select:maximum{1, nan, 2} == 2)
end

function t:minimum()
    local nan = 0/0
    assert(select:minimum{} == nil)
    assert(select:minimum{1} == 1)
    assert(select:minimum{1, 2} == 1)
    assert(select:minimum{1, 0} == 0)
    assert(select:minimum{nan} == nil)
    assert(select:minimum{nan, nan} == nil)
    assert(select:minimum{1, nan} == 1)
    assert(select:minimum{nan, 1} == 1)
    assert(select:minimum{1, nan, 0} == 0)
    assert(select:minimum{1, nan, 2} == 1)
end

function t:partition()
    for i = 1, 1000 do
        local t = rtable:new(100, 100)
        local r = math.random(#t)
        local p = math.random(r)
        local q = math.ceil((p + r) / 2)
        select:partition(t, p, q, r)
    end
end

function t:randomizedPartition()
    for i = 1, 1000 do
        local t = rtable:new(100, 100)
        local r = math.random(#t)
        local p = math.random(r)
        select:randomizedPartition(t, p, r)
    end
end

return t
