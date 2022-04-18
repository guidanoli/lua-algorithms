-- Directed Queue with Self-Loops

local Object = require "object"

-----------------------
-- Class
-----------------------

-- Queue : (number -> any)
local Queue = Object:inherit "Queue"

-----------------------
-- Public functions
-----------------------

function Queue:constructor()
    self.first = 0
    self.last = -1
end

-- Enqueue `value`
-- Parameters
--   value : any - value to be enqueued
function Queue:enqueue(value)
    local last = self.last + 1
    self.last = last
    self[last] = value
end

-- Dequeues `value`, returns true and `value`
-- If queue is empty, returns false and an error message
-- Return values
--   [1] : bool - success
--   [2] : any - dequeued value ([1] == true)
--         string - error message ([1] == false)
function Queue:dequeue()
    local first = self.first
    if first > self.last then
        return false, "queue is empty"
    else
        local value = self[first]
        self[first] = nil -- gc
        self.first = first + 1
        return true, value
    end
end

-- Checks if the queue is empty
-- Return value
--   [1] : bool - whether the queue is empty
function Queue:isEmpty()
    return self.first > self.last
end

-----------------------
-- Private functions
-----------------------

-----------------------
-- Return class
-----------------------

return Queue
