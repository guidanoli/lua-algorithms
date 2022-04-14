-- Graph neighbourhood

local Object = require "object"

-----------------------
-- Class
-----------------------

-- Edge : (any -> any)
local Edge = Object:inherit "Edge"

-- Neighbourhood : (Vertex -> Edge)
local Neighbourhood = Object:inherit "Neighbourhood"

-----------------------
-- Public functions
-----------------------

-- Add edge to vertex `w`
-- Returns nil if such edge already exists
-- Parameters
--   w  : Vertex
-- Return values
--   [1] : Edge
function Neighbourhood:addEdge(w)
    if self[w] == nil then
        local e = Edge:new()
        self[w] = e
        return e
    end
end

-- Remove edge to `w`
-- Parameters
--   w  : Vertex
function Neighbourhood:removeEdge(w)
    self[w] = nil
end

-- Get edge going to `w`
-- Returns nil if there is no such edge
-- Parameters
--   w   : Vertex
-- Return values
--   [1] : Edge?
function Neighbourhood:getEdge(w)
    return self[w]
end

-- Iterate through all the vertices and their
-- respective edges that connect to the main vertex
-- Yielded values
--   [1] : Vertex
--   [2] : Edge
function Neighbourhood:iter()
    return pairs(self)
end

-----------------------
-- Return class
-----------------------

return Neighbourhood
