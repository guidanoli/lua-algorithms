local select = require "select"

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

return t
