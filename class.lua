-- Object-Oriented Programming Class

local Class = {}

function Class:new(t)
    self.__index = self
    return setmetatable(t, self)
end

return Class
