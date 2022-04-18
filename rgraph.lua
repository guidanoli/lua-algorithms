-- Random graph

local Class = require "class"
local Graph = require "graph"

local RandomGraph = Class{
    name = "RandomGraph",
    parent = Graph,
}

function RandomGraph:new(n, k)
    Graph.new(self)
    local v = {}
    for i = 1, n do
        local vi = self:addVertex()
        vi.id = i
        v[i] = vi
    end
    for i = 1, n do
        local vi = v[i]
        for j = i+1, n do
            local vj = v[j]
            if math.random(n) <= k then
                local e = assert(self:addEdge(vi, vj))
                e.id = vi.id .. '-' .. vj.id
            end
        end
    end
end

function RandomGraph:getRandomVertex()
    local vertices = {}
    for v in self:iterVertices() do
        table.insert(vertices, v)
    end
    return vertices[math.random(#vertices)]
end

return RandomGraph
