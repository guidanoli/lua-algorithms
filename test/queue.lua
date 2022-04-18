local Queue = require "queue"

local t = {}

function t:all()
    local q = Queue:new()
    q:enqueue(nil)
    local ok, v = q:dequeue()
    assert(ok and v == nil)
    assert(q:isEmpty())
    local n = math.max(3, math.random(100))
    for i = 1, n do
        q:enqueue(i)
        assert(not q:isEmpty())
    end
    for i = 1, n do
        assert(not q:isEmpty())
        local ok, v = q:dequeue()
        assert(ok and v == i)
    end
    local ok, err = q:dequeue()
    assert(not ok and err == "queue is empty")
    assert(q:isEmpty())
end

return t
