-- Generic Graph

local Class = require "class"

-----------------------
-- Define class
-----------------------

-- EdgeData : table
-- VertexData : table
-- VertexHandle : (VertexHandle -> EdgeData)
-- Graph : (VertexHandle -> VertexData)
local Graph = Class:new{
    __name = "Graph",
}

-----------------------
-- Public functions
-----------------------

-- Create a new vertex and add it to the graph
-- Return values
--   [1] : table - vertex handle
--   [2] : table - vertex data
function Graph:addVertex()
    local v = {}
    local vdata = {}
    self[v] = vdata
    return v, vdata
end

-- Iterate through all vertices in the graph
-- Yielded values
--   [1] : table - vertex handle
--   [2] : table - vertex data
function Graph:iterVertices()
    return pairs(self)
end

-- Get data from vertex `v`
-- Returns nil if `v` is not in the graph
-- Parameters
--   v   : table  - vertex handle
-- Return values
--   [1] : table? - vertex data
function Graph:getVertex(v)
    return self[v]
end

-- Remove vertex `v` from the graph
-- Parameters
--   v   : table - vertex handle
-- Return values
--   [1] : bool  - vertex is removed
function Graph:removeVertex(v)
    assert(self:getVertex(v), "v is not in the graph")
    for w in pairs(self) do
        w[v] = nil
    end
    self[v] = nil
end

-- Add edge going from `v1` to `v2`
-- Parameters
--   v1  : table - vertex handle
--   v2  : table - vertex handle
-- Return values
--   [1] : table - edge data
function Graph:addEdge(v1, v2)
    assert(self:getVertex(v1), "v1 is not in the graph")
    assert(self:getVertex(v2), "v2 is not in the graph")
    local e = {}
    v1[v2] = e
    return e
end

-- Get edge going from `v1` to `v2`
-- Returns nil if there is no such edge
-- Parameters
--   v1  : table - vertex handle
--   v2  : table - vertex handle
-- Return values
--   [1] : table - edge data
function Graph:getEdge(v1, v2)
    assert(self:getVertex(v1), "v1 is not in the graph")
    assert(self:getVertex(v2), "v2 is not in the graph")
    return v1[v2]
end

-- Iterate through all neighbours of vertex `v`
-- Yields
--   [1] : table - neighbouring vertex handle
--   [2] : table - neighbouring edge data
function Graph:iterNeighbours(v)
    assert(self:getVertex(v), "v is not in the graph")
    return pairs(v)
end

-----------------------
-- Return class
-----------------------

return Graph
