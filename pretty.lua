-- Pretty printer

-----------------------
-- Define module
-----------------------

local Pretty = {
    INDENTING_STRING = "  "
}

-----------------------
-- Public functions
-----------------------

-- Converts an object into a string
function Pretty:format(o, indentStr, visitedTables)
    if type(o) == "table" then
        return self:_formatTable(o, indentStr or "", visitedTables or {})
    else
        return self:_formatNonTable(o, indentStr or "")
    end
end

-----------------------
-- Private functions
-----------------------

function Pretty:_indent(indentStr)
    return indentStr .. self.INDENTING_STRING
end

function Pretty:_formatElement(k, v, indentStr, visitedTables)
    local kStr = self:_formatNonTable(k, indentStr)
    local vStr = self:format(v, indentStr, visitedTables)
    local s = "[" .. kStr .. "] = " .. vStr
    return s
end

function Pretty:_formatTable(t, indentStr, visitedTables)
    if next(t) == nil then
        return "{}"
    elseif visitedTables[t] then
        return "{...}"
    else
        visitedTables[t] = true
        local s = "{\n"
        local nextIdentStr = self:_indent(indentStr)
        for k, v in pairs(t) do
            local element = self:_formatElement(k, v, nextIdentStr, visitedTables)
            s = s .. nextIdentStr .. element .. ",\n"
        end
        return s .. indentStr .. "}"
    end
end

function Pretty:_formatNonTable(o, indentStr)
    if type(o) == "string" then
        o = ("%q"):format(o)
        o = o:gsub("\n", "\n" .. indentStr)
        return o
    else
        return tostring(o)
    end
end

-----------------------
-- Return module
-----------------------

return Pretty
