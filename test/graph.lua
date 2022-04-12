local Graph = require "graph"

local t = {}

function t:addVertex()
    local g = Graph:new{}
    assert(g:getVertex{} == nil)
    local v, vdata = g:addVertex()
    assert(g:getVertex(v) == vdata)
    local found = false
    for u, udata in g:iterVertices() do
        if u == v then
            assert(udata == vdata)
            assert(not found)
            found = true
        end
    end
    assert(found)
end

local function testIterNeighbours(g, v1, e12, v2)
    local found = false
    for u, e in g:iterNeighbours(v1) do
        assert(u == v2)
        assert(e == e12)
        found = true
    end
    assert(found)
end

local function testNoNeighbours(g, v)
    for u, e in g:iterNeighbours(v) do
        assert(false)
    end
end

function t:addEdge()
    local g = Graph:new{}
    assertpcall("v1 is not in the graph", g.addEdge, g, {}, {})
    local v1 = g:addVertex()
    assertpcall("v2 is not in the graph", g.addEdge, g, v1, {})
    local v2 = g:addVertex()
    assertpcall("v1 is not in the graph", g.addEdge, g, {}, v2)
    testNoNeighbours(g, v1)
    testNoNeighbours(g, v2)
    local e12 = g:addEdge(v1, v2)
    assert(g:getEdge(v1, v2) == e12)
    assert(g:getEdge(v2, v1) == nil)
    testIterNeighbours(g, v1, e12, v2)
    testNoNeighbours(g, v2)
    local e21 = g:addEdge(v2, v1)
    assert(g:getEdge(v1, v2) == e12)
    assert(g:getEdge(v2, v1) == e21)
    testIterNeighbours(g, v1, e12, v2)
    testIterNeighbours(g, v2, e21, v1)
end

return t
