-- Graph search algorithms

local Graph = require "graph"

local Queue = require "queue"

-----------------------
-- Define module
-----------------------

local GraphSearch = {}

-----------------------
-- Public functions
-----------------------

-- Do a depth-first search on graph `g` from vertex `s`
-- Returns a DFS tree where each vertex has a "ref" field
-- that points to the original one
-- If vertex `s` is not in the graph, returns nil
-- Parameters
--   g   : Graph
--   s   : Vertex - first vertex to be visited
-- Return values
--   [1] : Graph - DFS tree
--   [2] : Vertex - vertex in DFS tree that references `s`
function GraphSearch:dfs(g, s)
    if g:hasVertex(s) then
        local tree = Graph()
        local visited = {}
        local ts = assert(self:_dfsVisit(g, tree, visited, s))
        return tree, ts
    end
end

-- Do a breadth-first search on graph `g` from vertex `s`
-- Returns a BFS tree where each vertex has a "ref" field
-- that points to the original one
-- If vertex `s` is not in the graph, returns nil
-- Parameters
--   g   : Graph
--   s   : Vertex - first vertex to be visited
-- Return values
--   [1] : Graph - BFS tree
--   [2] : Vertex - vertex in BFS tree that references `s`
function GraphSearch:bfs(g, s)
    if g:hasVertex(s) then
        local tree = Graph()
        local treeVertices = {} -- (GraphVertex -> TreeVertex)
        local treeVertexQueue = Queue() -- for TreeVertex only
        local ts = self:_addRef(tree, s)
        treeVertices[s] = ts
        treeVertexQueue:enqueue(ts)
        while true do
            local ok, tv = treeVertexQueue:dequeue()
            if not ok then
                break -- queue is empty
            end
            local v = tv.ref
            for w, e in g:iterEdges(v) do
                local tw = treeVertices[w]
                if tw == nil then
                    tw = self:_addRef(tree, w)
                    treeVertices[w] = tw
                    assert(tree:addEdge(tv, tw))
                    treeVertexQueue:enqueue(tw)
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
--   g   : Graph
--   tree : Graph - DFS tree
--   visited : (Vertex -> bool)
--   v : Vertex
-- Return values
--   [1] : Vertex - vertex in tree that references `v`
function GraphSearch:_dfsVisit(g, tree, visited, v)
    if not visited[v] then
        local tv = self:_addRef(tree, v)
        visited[v] = true
        for w, e in g:iterEdges(v) do
            local tw = self:_dfsVisit(g, tree, visited, w)
            if tw ~= nil then
                assert(tree:addEdge(tv, tw))
            end
        end
        return tv
    end
end

-- Adds a vertex in graph `g` with "ref" pointing to `v`
-- Parameters
--   g   : Graph
--   v : Vertex
-- Return values
--   [1] : Vertex - vertex added to `g`
function GraphSearch:_addRef(g, v)
    local vref = g:addVertex()
    vref.ref = v
    return vref
end

-----------------------
-- Return module
-----------------------

return GraphSearch
