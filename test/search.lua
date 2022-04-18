local Graph = require "graph"
local GraphSearch = require "search"
local RandomGraph = require "rgraph"

local t = {}

function t:dfs()
    local n = 100
    local k = 10
    local g = RandomGraph:new(n, k)
    assert(GraphSearch:dfs(g, {}) == nil)

    local o = g:getRandomVertex()
    local tree = assert(GraphSearch:dfs(g, o))

    -- Check that the BFS tree has a subset
    -- of the nodes of the original graph
    -- including origin vertex
    for tv in tree:iterVertices() do
        local v = assert(tv.ref)
        assert(g:hasVertex(v))
        assert(not v.added)
        v.added = true
    end
    assert(o.added)

    -- Check that every edge in the tree
    -- exists in the original graph
    for tv in tree:iterVertices() do
        local v = tv.ref
        for tw, te in tree:iterEdges(tv) do
            local w = tw.ref
            assert(g:getEdge(v, w) ~= nil)
        end
    end
end

function t:bfs()
    local n = 5
    local k = 2
    local g = RandomGraph:new(n, k)
    assert(GraphSearch:bfs(g, {}) == nil)

    local o = g:getRandomVertex()
    local tree = assert(GraphSearch:bfs(g, o))

    -- Check that the BFS tree has a subset
    -- of the nodes of the original graph
    -- including origin vertex
    for tv in tree:iterVertices() do
        local v = assert(tv.ref)
        assert(g:hasVertex(v))
        assert(v.added == nil)
        v.added = true
    end
    assert(o.added)

    -- Check that every edge in the tree
    -- exists in the original graph
    for tv in tree:iterVertices() do
        local v = assert(tv.ref)
        for tw, te in tree:iterEdges(tv) do
            local w = assert(tw.ref)
            assert(g:getEdge(v, w))
        end
    end
end

return t
