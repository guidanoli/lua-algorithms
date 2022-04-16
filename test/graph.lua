local Graph = require "graph"
local RandomGraph = require "rgraph"

local t = {}

function t:badArguments()
    local g = Graph:new()            -- G = <V, E> = <{}, {}>
    assert(g:hasVertex(nil) == false)
    g:removeVertex(nil)
    assert(g:addEdge(nil, nil) == nil)
    assert(g:getEdge(nil, nil) == nil)
    g:removeEdge(nil, nil)
    assertnoloop(g:iterEdges(nil))

    local v = g:addVertex()          -- G = <{v}, {}>
    assert(g:addEdge(v, nil) == nil)
    assert(g:addEdge(nil, v) == nil)
    assert(g:getEdge(v, nil) == nil)
    assert(g:getEdge(nil, v) == nil)
    g:removeEdge(v, nil)
    g:removeEdge(nil, v)
end

function t:addAndRemoveVertex()
    local g = Graph:new()            -- G = <V, E> = <{}, {}>
    assertnoloop(g:iterVertices())
    assert(g:hasVertex{} == false)

    local v = g:addVertex()          -- G = <{v}, {}>
    assert(g:hasVertex(v) == true)
    assertloop({{v}}, g:iterVertices())

    g:removeVertex(v)                -- G = <{}, {}>
    assert(g:hasVertex(v) == false)
end

local function assertnoedges(g, v, w)
    assertnoloop(g:iterEdges(v))
    assertnoloop(g:iterEdges(w))
    assert(g:getEdge(v, w) == nil)
    assert(g:getEdge(w, v) == nil)
end

function t:addAndRemoveEdge()
    local g = Graph:new()            -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>
    assertnoloop(g:iterEdges(v))

    local w = g:addVertex()          -- G = <{v, w}, {}>
    assert(v ~= w)
    assertnoedges(g, v, w)

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>
    assert(g:getEdge(v, w) == e)
    assert(g:getEdge(w, v) == e)
    assertloop({{w, e}}, g:iterEdges(v))
    assertloop({{v, e}}, g:iterEdges(w))

    g:removeEdge(v, w)                -- G = <{v, w}, {}>
    assertnoedges(g, v, w)

    g:removeVertex(w)                 -- G = <{v}, {}>
    assertnoedges(g, v, w)

    g:removeVertex(v)                 -- G = <{}, {}>
    assertnoedges(g, v, w)
end

function t:removeOriginVertex()
    local g = Graph:new()            -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>

    local w = g:addVertex()          -- G = <{v, w}, {}>

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>

    g:removeVertex(v)                -- G = <{w}, {}>
    assert(g:hasVertex(v) == false)
    assert(g:hasVertex(w) == true)
    assertnoedges(g, v, w)
end

function t:removeDestinationVertex()
    local g = Graph:new()            -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>

    local w = g:addVertex()          -- G = <{v, w}, {}>

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>

    g:removeVertex(w)                -- G = <{v}, {}>
    assert(g:hasVertex(v) == true)
    assert(g:hasVertex(w) == false)
    assertnoedges(g, v, w)
end

function t:dfs()
    local n = 100
    local k = 10
    local g = RandomGraph:new(n, k)
    assert(g:dfs{} == nil)

    local o = g:getRandomVertex()
    local tree = assert(g:dfs(o))

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
    assert(g:bfs{} == nil)

    local o = g:getRandomVertex()
    local tree = assert(g:bfs(o))

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
