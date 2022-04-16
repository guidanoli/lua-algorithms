-- Object-Oriented Programming

local Object = {}
setmetatable(Object, {
    __name = "Object",
    __parent = Object,
})

function Object:inherit(name)
    assert(self:isClass())
    local mt = {
        __index = self,
        __name = name,
        __parent = self,
    }
    local cls = setmetatable({}, mt)
    return cls
end

function Object:new(...)
    assert(self:isClass())
    local mt = {
        __index = self,
        __name = self:getClassName(),
        __class = self,
    }
    local obj = setmetatable({}, mt)
    local init = self.constructor
    if init ~= nil then
        init(obj, ...)
    end
    return obj
end

local function getmetafield(obj, field)
    local mt = getmetatable(obj)
    return mt and mt[field]
end

function Object:getClass()
    return getmetafield(self, "__class")
end

function Object:getParentClass()
    return getmetafield(self, "__parent")
end

function Object:getClassName()
    return getmetafield(self, "__name")
end

function Object:isClass()
    if self:getParentClass() then
        return true
    else
        return false, "not a class"
    end
end

function Object:isObject()
    if self:getClass() then
        return true
    else
        return false, "not an object"
    end
end

return Object
