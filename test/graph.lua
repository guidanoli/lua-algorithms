local Graph = require "graph"

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
    local g = Graph:new()
    local n = 10
    for i = 1, n do
        local v = g:addVertex()
        v.id = i
    end
    for v in g:iterVertices() do
        for w in g:iterVertices() do
            if v.id < w.id then
                local e = g:addEdge(v, w)
            end
        end
    end

    -- Do a DFS in the graph
    local forest, ncomponents = g:dfs()
    assert(forest)
    assert((n == 0 and ncomponents == 0) or
           (ncomponents >= 1 and ncomponents <= n))

    -- Check that every vertex in the forest has
    -- a reference to a vertex in the graph and
    -- that every vertex in the graph is referenced
    -- in exactly one vertex in the forest
    local fn = 0
    for fv in forest:iterVertices() do
        local v = assert(fv.ref)
        assert(g:hasVertex(v))
        assert(not v.traversed)
        v.traversed = true
        fn = fn + 1
    end
    assert(fn == n)

    -- Check that every vertex is in a valid
    -- connected component
    local components = {}
    for fv in forest:iterVertices() do
        local v = fv.ref
        local cid = assert(fv.cid)
        assert(cid >= 1 and cid <= ncomponents)
        if components[cid] == nil then
            components[cid] = {}
        end
        components[cid][v] = true
    end
    assert(#components == ncomponents)

    -- Check that vertices that are connected are
    -- in the same connected component
    for fv in forest:iterVertices() do
        local v = fv.ref
        for fw in forest:iterVertices() do
            local w = fw.ref
            local fe = forest:getEdge(fv, fw)
            local e = g:getEdge(v, w)
            if fe ~= nil then
                assert(fe.ref == e)
                assert(fv.cid == fw.cid)
            end
        end
    end

    -- Check that vertices from different connected
    -- components are not connected with one another
    for cid1, component1 in pairs(components) do
        for cid2, component2 in pairs(components) do
            if cid1 < cid2 then
                for v1 in pairs(component1) do
                    for v2 in pairs(component2) do
                        assert(g:getEdge(v1, v2) == nil)
                    end
                end
            end
        end
    end
end

function t:dfs()
    local g = Graph:new()
    local n = 10
    for i = 1, n do
        local v = g:addVertex()
        v.id = i
    end
    for v in g:iterVertices() do
        for w in g:iterVertices() do
            if v.id < w.id then
                local e = g:addEdge(v, w)
            end
        end
    end

    -- Do a DFS in the graph
    local forest = assert(g:dfs())

    -- Check that every vertex in the forest has
    -- a reference to a vertex in the graph and
    -- that every vertex in the graph is referenced
    -- in exactly one vertex in the forest
    local fn = 0
    for fv in forest:iterVertices() do
        local v = assert(fv.ref)
        assert(g:hasVertex(v))
        assert(not v.traversed)
        v.traversed = true
        fn = fn + 1
    end
    assert(fn == n)

    -- Check that every edge in the forest
    -- references an edge in the graph
    for fv in forest:iterVertices() do
        local v = fv.ref
        for fw, fe in forest:iterEdges(fv) do
            local w = fw.ref
            local e = g:getEdge(v, w)
            assert(fe.ref == e)
        end
    end
end

return t
