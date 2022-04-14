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

-- Enqueues value if it is not nil
-- Returns whether value was enqueued
function Queue:enqueue(value)
    if value == nil then
        return false
    else
        local last = self.last + 1
        self.last = last
        self[last] = value
        return true
    end
end

-- Dequeues value
-- Returns value or nil of the queue is empty
function Queue:dequeue()
    local first = self.first
    if first > self.last then
        return nil
    else
        local value = self[first]
        self[first] = nil -- gc
        self.first = first + 1
        return value
    end
end

-- Checks if the queue is empty
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
