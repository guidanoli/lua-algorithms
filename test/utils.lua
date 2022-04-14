-- Utilities for testing

function assertloop(yields, f, s, var)
    local i = 0
    while true do
        local vars = table.pack(f(s, var))
        var = vars[1]
        if var == nil then
            break
        end
        i = i + 1
        local yi = assert(yields[i], "looped too much")
        for j, yij in ipairs(yi) do
            local reason = ("yield #%d from loop #%d differs"):format(i, j)
            assert(vars[j] == yij, reason)
        end
    end
    assert(#yields == i, "looped too few")
end

function assertnoloop(f, s, var)
    assert(f(s, var) == nil, "looped once")
end

function assertpcall(patt, f, ...)
    local ok, ret = pcall(f, ...)
    assert(not ok, "function did not throw")
    local reason = ("%q not in %q"):format(patt, ret)
    assert(ret:find(patt, 1, true), reason)
end
