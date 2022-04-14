-- Directed Graph with Self-Loops

local Object = require "object"
local Vertex = require "vertex"
local Edge = require "edge"
local Neighbourhood = require "neighbourhood"
local Queue = require "queue"

-----------------------
-- Class
-----------------------

-- Graph : (Vertex -> Neighbourhood)
local Graph = Object:inherit "Graph"

-----------------------
-- Public functions
-----------------------

function Graph:constructor()
    self.n = {}
end

-- Add a new vertex to the graph
-- Return values
--   [1] : Vertex
function Graph:addVertex()
    local v = Vertex:new()
    self.n[v] = Neighbourhood:new()
    return v
end

-- Check if vertex exists in graph
-- Parameters
--   v   : Vertex
-- Return values
--   [1] : bool
function Graph:hasVertex(v)
    return self.n[v] ~= nil
end

-- Remove vertex `v` from the graph
-- Parameters
--   v   : Vertex
function Graph:removeVertex(v)
    if self.n[v] then
        for _, wn in pairs(self.n) do
            wn:removeEdge(v)
        end
        self.n[v] = nil
    end
end

-- Iterate through all the vertices
-- Yielded values
--   [1] : Vertex
function Graph:iterVertices()
    local v
    return function()
        v = next(self.n, v)
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
    local vn = self.n[v]
    local wn = self.n[w]
    if vn and wn then
        local e = Edge:new()
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
    local vn = self.n[v]
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
    local vn = self.n[v]
    local wn = self.n[w]
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
    local vn = self.n[v]
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
-- "cid" with a number that indicates the
-- connected component it is in.
-- Return values
--   [1] : Graph - DFS forest
--   [2] : number - number of connected components
function Graph:dfs()
    local visited = {}
    local ncomponents = 0
    local forest = Graph:new()
    for v in self:iterVertices() do
        if not visited[v] then
            local cid = ncomponents + 1
            local fv = forest:addVertex()
            self:_dfs(v, fv, visited, forest, cid)
            ncomponents = ncomponents + 1
        end
    end
    return forest, ncomponents
end

-- Do a breadth-first search on the graph
-- Returns a BFS forest
function Graph:bfs()
    local visited = {}
    local queue = Queue:new()
    local forest = Graph:new()
    for u in self:iterVertices() do
        if not visited[u] then
            local fu = forest:addVertex()
            fu.ref = u
            queue:enqueue(u)
            visited[u] = true
            while not queue:isEmpty() do
                u = queue:dequeue()
                for v, uv in self:iterEdges(u) do
                    if not visited[v] then
                        local fv = forest:addVertex()
                        fv.ref = v
                        local fuv = forest:addEdge(fu, fv)
                        fuv.ref = uv
                        visited[v] = true
                        queue:enqueue(v)
                    end
                end
            end
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
--   cid : number - component id
function Graph:_dfs(v, fv, visited, forest, cid)
    assert(fv)
    assert(visited)
    assert(forest)
    fv.ref = assert(v)
    fv.cid = assert(cid)
    visited[v] = true
    for w, e in self:iterEdges(v) do
        if not visited[w] then
            local fw = forest:addVertex()
            local fe = forest:addEdge(fv, fw)
            fe.ref = e
            self:_dfs(w, fw, visited, forest, cid)
        end
    end
end

-----------------------
-- Return class
-----------------------

return Graph
