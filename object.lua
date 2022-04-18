-- Object-Oriented Programming
--
-- Like Python, all classes inherit from the Object class
-- You can create a class by calling its "inherit" method
-- You can instantiate a class by calling its "new" method
-- A class can have a constructor by having a "constructor" method
-- The constructor will be called with the arguments passed to the "new" method

local Object = setmetatable({}, {
    __name = "Object",
    __isclass = true,
})

-- Default constructor
function Object:constructor(...)
    return ...
end

-- Create a class by inheritance
-- Parameters
--   self : table - class to be inherited from
--   name : string or nil - name for new class
-- Return values
--   [1] : table - newly created class
function Object:inherit(name)
    assert(self:isClass())
    return setmetatable({}, {
        __index = self,
        __name = name,
        __parent = self,
        __isclass = true,
    })
end

-- Create an object by instantiation
-- Parameters
--   self : table - class to be instantiated
--   ...  : any - arguments passed to constructor
--                (if the class or some parent class
--                defines one)
-- Return values
--   [1]  : table - newly instantiated object
--   ...  : any - values returned by the constructor
function Object:new(...)
    assert(self:isClass())
    local obj = setmetatable({}, {
        __index = self,
        __name = self:getClassName(),
        __class = self,
        __isclass = false,
    })
    return obj, obj:constructor(...)
end

local function getmetafield(obj, field)
    local mt = getmetatable(obj)
    return mt and rawget(mt, field)
end

-- Get class of an object
-- Parameters
--   self : table - object
-- Return values
--   [1] : table - class of `self`
function Object:getClass()
    return getmetafield(self, "__class")
end

-- Get parent of a class
-- Parameters
--   self : table - class
-- Return values
--   [1] : table - parent class of `self`
function Object:getParentClass()
    return getmetafield(self, "__parent")
end

-- Get name of an object's class or of a class
-- Parameters
--   self : table - object or class
-- Return values
--   [1] : table - name of `self` (if a class) or
--                 name of class of `self` (if an object)
function Object:getClassName()
    return getmetafield(self, "__name")
end

-- Check if `self` is a class
-- Parameters
--   self : table - object or class
-- Return values
--   [1] : bool - whether `self` is a class or not
--   [2] : string - error message of [1] is `false`
function Object:isClass()
    if getmetafield(self, "__isclass") then
        return true
    else
        return false, "not a class"
    end
end

return Object
