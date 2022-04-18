local Graph = require "graph"
local RandomGraph = require "rgraph"

local t = {}

function t:badArguments()
    local g = Graph()                -- G = <V, E> = <{}, {}>
    assert(g:hasVertex(nil) == false)
    g:removeVertex(nil)
    assert(g:addEdge(nil, nil) == nil)
    assert(g:getEdge(nil, nil) == nil)
    g:removeEdge(nil, nil)
    assert(noloop(g:iterEdges(nil)))

    local v = g:addVertex()          -- G = <{v}, {}>
    assert(g:addEdge(v, nil) == nil)
    assert(g:addEdge(nil, v) == nil)
    assert(g:getEdge(v, nil) == nil)
    assert(g:getEdge(nil, v) == nil)
    g:removeEdge(v, nil)
    g:removeEdge(nil, v)
end

function t:addAndRemoveVertex()
    local g = Graph()                -- G = <V, E> = <{}, {}>
    assert(noloop(g:iterVertices()))
    assert(g:hasVertex{} == false)

    local v = g:addVertex()          -- G = <{v}, {}>
    assert(g:hasVertex(v) == true)
    assert(loops({{v}}, g:iterVertices()))

    g:removeVertex(v)                -- G = <{}, {}>
    assert(g:hasVertex(v) == false)
end

local function assertnoedges(g, v, w)
    assert(noloop(g:iterEdges(v)))
    assert(noloop(g:iterEdges(w)))
    assert(g:getEdge(v, w) == nil)
    assert(g:getEdge(w, v) == nil)
end

function t:addAndRemoveEdge()
    local g = Graph()                -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>
    assert(noloop(g:iterEdges(v)))

    local w = g:addVertex()          -- G = <{v, w}, {}>
    assert(v ~= w)
    assertnoedges(g, v, w)

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>
    assert(g:getEdge(v, w) == e)
    assert(g:getEdge(w, v) == e)
    assert(loops({{w, e}}, g:iterEdges(v)))
    assert(loops({{v, e}}, g:iterEdges(w)))

    g:removeEdge(v, w)                -- G = <{v, w}, {}>
    assertnoedges(g, v, w)

    g:removeVertex(w)                 -- G = <{v}, {}>
    assertnoedges(g, v, w)

    g:removeVertex(v)                 -- G = <{}, {}>
    assertnoedges(g, v, w)
end

function t:removeOriginVertex()
    local g = Graph()                -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>

    local w = g:addVertex()          -- G = <{v, w}, {}>

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>

    g:removeVertex(v)                -- G = <{w}, {}>
    assert(g:hasVertex(v) == false)
    assert(g:hasVertex(w) == true)
    assertnoedges(g, v, w)
end

function t:removeDestinationVertex()
    local g = Graph()                -- G = <V, E> = <{}, {}>

    local v = g:addVertex()          -- G = <{v}, {}>

    local w = g:addVertex()          -- G = <{v, w}, {}>

    local e = g:addEdge(v, w)        -- G = <{v, w}, {e}>

    g:removeVertex(w)                -- G = <{v}, {}>
    assert(g:hasVertex(v) == true)
    assert(g:hasVertex(w) == false)
    assertnoedges(g, v, w)
end

return t
