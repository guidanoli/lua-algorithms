-- Graph neighbourhood

local Class = require "class"

-----------------------
-- Class
-----------------------

-- Neighbourhood : (Vertex -> Edge)
local Neighbourhood = Class{name = "Neighbourhood"}

-----------------------
-- Public functions
-----------------------

-- Set edge to vertex `w`
-- Parameters
--   w  : Vertex
function Neighbourhood:setEdge(w, e)
    self[w] = e
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
