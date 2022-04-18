-- Undirected Graph with Self-Loops

local Class = require "class"

local Neighbourhood = require "nbhood"

-----------------------
-- Class
-----------------------

-- Vertex : (any -> any)
local Vertex = Class{name = "Vertex"}

-- Edge : (any -> any)
local Edge = Class{name = "Edge"}

-- Graph : (Vertex -> Neighbourhood)
local Graph = Class{name = "Graph"}

-----------------------
-- Public functions
-----------------------

-- Add a new vertex to the graph
-- Return values
--   [1] : Vertex
function Graph:addVertex()
    local v = Vertex()
    self[v] = Neighbourhood()
    return v
end

-- Check if vertex exists in graph
-- Parameters
--   v   : Vertex
-- Return values
--   [1] : bool
function Graph:hasVertex(v)
    return self[v] ~= nil
end

-- Remove vertex `v` from the graph
-- Parameters
--   v   : Vertex
function Graph:removeVertex(v)
    if self[v] then
        for _, wn in pairs(self) do
            wn:removeEdge(v)
        end
        self[v] = nil
    end
end

-- Iterate through all the vertices
-- Yielded values
--   [1] : Vertex
function Graph:iterVertices()
    local v
    return function()
        v = next(self, v)
        return v
    end
end

-- Add edge between vertices `v` and `w`
-- If `v` or `w` don't exist, returns nil
-- If edge already exists, is is overwritten
-- Parameters
--   v  : Vertex
--   w  : Vertex
-- Return values
--   [1] : Edge
function Graph:addEdge(v, w)
    local vn = self[v]
    local wn = self[w]
    if vn and wn then
        local e = Edge()
        vn:setEdge(w, e)
        wn:setEdge(v, e)
        return e
    end
end

-- Get edge between vertices `v` and `w`
-- Returns nil if one of the vertices is not in the graph
-- or if the edge itself doesn't exist
-- Parameters
--   v  : Vertex
--   w  : Vertex
-- Return values
--   [1] : Edge
function Graph:getEdge(v, w)
    local vn = self[v]
    if vn then
        return vn:getEdge(w)        
    end
end

-- Remove edge between vertices `v` and `w`
-- Does nothing if either vertex is not in the graph
-- Parameters
--   v  : Vertex
--   w  : Vertex
function Graph:removeEdge(v, w)
    local vn = self[v]
    local wn = self[w]
    if vn and wn then
        vn:removeEdge(w)
        wn:removeEdge(v)
    end
end

-- Iterate through all the edges and neighbours of vertex `v`
-- If `v` is not in the graph, makes no iteration
-- Parameters
--   v   : Vertex
-- Yielded values
--   [1] : Vertex
--   [2] : Edge
function Graph:iterEdges(v)
    local vn = self[v]
    if vn then
        return vn:iter()
    else
        return getmetatable -- noop
    end
end

-----------------------
-- Return class
-----------------------

return Graph
