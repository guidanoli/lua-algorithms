-- Directed Graph with Self-Loops

local Object = require "object"
local Neighbourhood = require "neighbourhood"

-----------------------
-- Class
-----------------------

-- Vertex : (any -> any)
local Vertex = Object:inherit "Vertex"

-- Edge : (any -> any)
local Edge = Object:inherit "Edge"

-- Graph : (Vertex -> Neighbourhood)
local Graph = Object:inherit "Graph"

-----------------------
-- Public functions
-----------------------

function Graph:constructor()
    self.from = {}
    self.to = {}
end

-- Add a new vertex to the graph
-- Return values
--   [1] : Vertex
function Graph:addVertex()
    local v = Vertex:new()
    self.from[v] = Neighbourhood:new()
    self.to[v] = Neighbourhood:new()
    return v
end

-- Check if vertex exists in graph
-- Parameters
--   v   : Vertex
-- Return values
--   [1] : bool
function Graph:hasVertex(v)
    return self.from[v] ~= nil
end

-- Remove vertex `v` from the graph
-- Parameters
--   v   : Vertex
function Graph:removeVertex(v)
    if self.from[v] then
        for _, wn in pairs(self.from) do
            wn:removeEdge(v)
        end
        for _, wn in pairs(self.to) do
            wn:removeEdge(v)
        end
        self.from[v] = nil
        self.to[v] = nil
    end
end

-- Iterate through all the vertices
-- Yielded values
--   [1] : Vertex
function Graph:iterVertices()
    local v
    return function()
        v = next(self.from, v)
        return v
    end
end

-- Add edge from vertex `v` to vertex `w`
-- If `v` or `w` don't exist, returns nil
-- If edge already exists, is is overwritten
-- Parameters
--   v  : Vertex
--   w  : Vertex
-- Return values
--   [1] : Edge
function Graph:addEdge(v, w)
    local fromv = self.from[v]
    local tow = self.to[w]
    if fromv and tow then
        local e = Edge:new()
        fromv:setEdge(w, e)
        tow:setEdge(v, e)
        return e
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
    local vn = self.from[v]
    if vn then
        return vn:getEdge(w)        
    end
end

-- Remove edge from vertex `v` to vertex `w`
-- Parameters
--   v  : Vertex
--   w  : Vertex
function Graph:removeEdge(v, w)
    local fromv = self.from[v]
    local tow = self.to[w]
    if fromv and tow then
        fromv:removeEdge(w)
        tow:removeEdge(v)
    end
end

-- Iterate through all the out-edges and out-neighbours of vertex `v`
-- If `v` is not in the graph, makes no iteration
-- Parameters
--   v   : Vertex
-- Yielded values
--   [1] : Vertex
--   [2] : Edge
function Graph:iterOutEdges(v)
    local vn = self.from[v]
    if vn then
        return vn:iter()
    else
        return getmetatable -- noop
    end
end

-- Iterate through all the in-edges and in-neighbours of vertex `v`
-- If `v` is not in the graph, makes no iteration
-- Parameters
--   v   : Vertex
-- Yielded values
--   [1] : Vertex
--   [2] : Edge
function Graph:iterInEdges(v)
    local vn = self.to[v]
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
-- strongly connected component it is in.
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
    for w, e in self:iterOutEdges(v) do
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
