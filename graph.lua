-- Directed Graph with Self-Loops

local Object = require "object"
local Neighbourhood = require "neighbourhood"

-----------------------
-- Class
-----------------------

-- Vertex : (any -> any)
local Vertex = Object:inherit "Vertex"

-- Graph : (Vertex -> Neighbourhood)
local Graph = Object:inherit "Graph"

-----------------------
-- Public functions
-----------------------

-- Add a new vertex to the graph
-- Return values
--   [1] : Vertex
function Graph:addVertex()
    local v = Vertex:new()
    self[v] = Neighbourhood:new()
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

-- Add edge from vertex `v` to vertex `w`
-- Returns nil if one of the vertices is not in the graph
-- or if such edge already exists in the graph
-- Parameters
--   v  : Vertex
--   w  : Vertex
-- Return values
--   [1] : Edge
function Graph:addEdge(v, w)
    local vn = self[v]
    if vn and self[w] then
        return vn:addEdge(w)
    end
end

-- Get edge from vertex `v` to vertex `w`
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

-- Remove edge from vertex `v` to vertex `w`
-- Parameters
--   v  : Vertex
--   w  : Vertex
function Graph:removeEdge(v, w)
    local vn = self[v]
    if vn and self[w] then
        vn:removeEdge(w)
    end
end

-- Iterate through all the edges and the vertices they
-- connect `v` to
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

-- Do a depth-first search on the graph
-- Return a DFS forest where each vertex
-- and edge has a field called "ref" that
-- points to the original in the graph,
-- and where each vertex has a field called
-- "cid" with serial number indicating the
-- connected component the vertex is in.
-- Return values
--   [1] : Graph - DFS forest
function Graph:dfs()
    local visited = {}
    local forest = Graph:new()
    for v in self:iterVertices() do
        if not visited[v] then
            local fv = forest:addVertex()
            self:_dfs(v, fv, visited, forest)
        end
    end
    return forest
end

-----------------------
-- Private functions
-----------------------

-- Visit vertex `v` in a depth-first search
-- Parameters
--   v : Vertex
--   fv : Vertex - vertex in `forest` that references `v`
--   visited : (Vertex -> bool)
--   forest : Graph - DFS forest
function Graph:_dfs(v, fv, visited, forest)
    fv.ref = v
    visited[v] = true
    for w, e in self:iterEdges(v) do
        if not visited[w] then
            local fw = forest:addVertex()
            local fe = forest:addEdge(fv, fw)
            fe.ref = e
            self:_dfs(w, fw, visited, forest)
        end
    end
end

-----------------------
-- Return class
-----------------------

return Graph
