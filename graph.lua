-- Undirected Graph with Self-Loops

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

-- Do a depth-first search on the graph from vertex `s`
-- Returns a DFS tree where each vertex has a "ref" field
-- that points to the original one
-- If vertex `s` is not in the graph, returns nil
-- Parameters
--   s   : Vertex - first vertex to be visited
-- Return values
--   [1] : Graph - DFS tree
--   [2] : Vertex - vertex in DFS tree that references `s`
function Graph:dfs(s)
    if self:hasVertex(s) then
        local tree = Graph:new()
        local visited = {}
        local ts = assert(self:_dfsVisit(tree, visited, s))
        return tree, ts
    end
end

-- Do a breadth-first search on the graph from vertex `s`
-- Returns a BFS tree where each vertex has a "ref" field
-- that points to the original one
-- If vertex `v` is not in the graph, returns nil
-- Parameters
--   s   : Vertex - first vertex to be visited
-- Return values
--   [1] : Graph - BFS tree
--   [2] : Vertex - vertex in DFS tree that references `v`
function Graph:bfs(s)
    if self:hasVertex(s) then
        local tree = Graph:new()
        local treeVertices = {} -- (GraphVertex -> TreeVertex)
        local treeVertexQueue = Queue:new() -- for TreeVertex only
        local ts = tree:_addRef(s)
        treeVertices[s] = ts
        assert(treeVertexQueue:enqueue(ts))
        while not treeVertexQueue:isEmpty() do
            local tv = assert(treeVertexQueue:dequeue())
            local v = tv.ref
            for w, e in self:iterEdges(v) do
                local tw = treeVertices[w]
                if tw == nil then
                    tw = tree:_addRef(w)
                    treeVertices[w] = tw
                    assert(tree:addEdge(tv, tw))
                    assert(treeVertexQueue:enqueue(tw))
                end
            end
        end
        return tree, ts
    end
end

-----------------------
-- Private functions
-----------------------

-- Visit vertex `v` in a depth-first search
-- If `v` has been visited already, returns nil
-- Parameters
--   tree : Graph - DFS tree
--   visited : (Vertex -> bool)
--   v : Vertex
-- Return values
--   [1] : Vertex - vertex in tree that references `v`
function Graph:_dfsVisit(tree, visited, v)
    if not visited[v] then
        local tv = tree:_addRef(v)
        visited[v] = true
        for w, e in self:iterEdges(v) do
            local tw = self:_dfsVisit(tree, visited, w)
            if tw ~= nil then
                assert(tree:addEdge(tv, tw))
            end
        end
        return tv
    end
end

-- Adds a vertex with "ref" pointing to `v`
function Graph:_addRef(v)
    local vref = self:addVertex()
    vref.ref = v
    return vref
end

-----------------------
-- Return class
-----------------------

return Graph
