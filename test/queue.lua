local Queue = require "queue"

local t = {}

function t:all()
    local q = Queue:new()
    assert(q:enqueue(nil) == false)
    assert(q:dequeue() == nil)
    assert(q:isEmpty())
    local n = math.max(3, math.random(100))
    for i = 1, n do
        assert(q:enqueue(i) == true)
        assert(not q:isEmpty())
    end
    for i = 1, n do
        assert(not q:isEmpty())
        assert(q:dequeue() == i)
    end
    assert(q:dequeue() == nil)
    assert(q:isEmpty())
end

return t
