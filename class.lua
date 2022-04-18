-- Object-Oriented Programming Class

local BaseClass = {}
function BaseClass.init() end

-- Create a class
-- Classes can be instantiated by calling them like functions
-- Any argument is passed to the "init" method of the class
-- Parameters
--   t : table - class options
--     name : string or nil - class name
--     parent : table or nil - parent class
-- Return
--   [1] : table - newly created class
return function(t)
    local name = t.name
    local parent = t.parent or BaseClass
    return setmetatable({}, {
        __index = parent,
        __name = name,
        __metatable = false,
        __call = function(cls, ...)
            local obj = setmetatable({}, {
                __index = cls,
                __name = name,
                __metatable = false,
            })
            obj:init(...)
            return obj
        end
    })
end
