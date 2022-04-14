-- Object-Oriented Programming

local Object = setmetatable({}, {
    __name = "Object",
    __type = "class",
})

function Object:inherit(name)
    assert(self:_isClass())
    local mt = {
        __index = self,
        __name = name,
        __type = "class",
    }
    local cls = setmetatable({}, mt)
    return cls
end

function Object:new(...)
    assert(self:_isClass())
    local mt = {
        __index = self,
        __name = self:getClassName(),
        __type = "object",
    }
    local obj = setmetatable({}, mt)
    local init = self.constructor
    if init ~= nil then
        init(obj, ...)
    end
    return obj
end

function Object:getClass()
    assert(self:_isObject())
    return getmetatable(self).__index
end

function Object:getParentClass()
    assert(self:_isClass())
    return getmetatable(self).__index
end

function Object:getClassName()
    return getmetatable(self).__name
end

function Object:isClass()
    return self:_getMetaType() == "class"
end

function Object:isObject()
    return self:_getMetaType() == "object"
end

function Object:_getMetaType()
    return getmetatable(self).__type
end

function Object:_isClass()
    if self:isClass() then
        return true
    else
        return false, "not a class"
    end
end

function Object:_isObject()
    if self:isObject() then
        return true
    else
        return false, "not an object"
    end
end

return Object
