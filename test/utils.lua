-- Utility functions for testing

function loops(yields, f, s, var)
    local i = 0
    while true do
        local vars = {f(s, var)}
        var = vars[1]
        if var == nil then
            break
        end
        i = i + 1
        local yi = yields[i]
        if yi == nil then
            return false, "looped too much"
        end
        local ok, k = eqtables(yi, vars)
        if not ok then
            return false, ("loop #%d, value #%s"):format(i, k)
        end
    end
    if #yields == i then
        return true
    else
        return false, "looped too few"
    end
end

function noloop(f, s, var)
    if f(s, var) == nil then
        return true
    else
        return false, "looped once"
    end
end

function pcallfind(patt, f, ...)
    local ok, ret = pcall(f, ...)
    if ok then
        if ret:find(patt, 1, true) then
            return true
        else
            return false, ("%q not in %q"):format(patt, ret)
        end
    else
        return false, "function did not throw"
    end
end

function eq(a, b)
    if type(a) == 'table' and type(b) == 'table' then
        return eqtables(a, b)
    else
        if a == b then
            return true
        else
            return false, ("%s != %s"):format(a, b)
        end
    end
end

function eqtables(a, b)
    local k = difftables(a, b)
    if k == nil then
        local k = difftables(b, a)
        if k == nil then
            return true
        else
            return false, k
        end
    else
        return false, k
    end
end

function difftables(a, b)
    for k, ak in pairs(a) do
        if ak ~= b[k] then
            return k
        end
    end
end
