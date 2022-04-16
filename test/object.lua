local Object = require "object"

local t = {}

function t:all()
    assert(Object:getClassName() == "Object")
    assert(Object:getParentClass() == Object)
    assert(Object:isClass())
    assert(not Object:isObject())

    local Animal = Object:inherit "Animal"

    assert(Animal:getClassName() == "Animal")
    assert(Animal:getParentClass() == Object)
    assert(Animal:isClass())
    assert(not Animal:isObject())

    function Animal:constructor(name)
        self.name = name
        Animal.count = (Animal.count or 0) + 1
    end
    
    assert(Animal.count == nil)

    local giraffe = Animal:new "Gerald"

    assert(Animal.count == 1)
    assert(giraffe:getClassName() == "Animal")
    assert(giraffe:getClass() == Animal)
    assert(giraffe:isObject())
    assert(not giraffe:isClass())
    
    function Animal:say(something)
        return self.name .. " says " .. something
    end

    function Animal:shout()
        return self.name .. " shouts"
    end
    
    assert(giraffe:say "hello" == "Gerald says hello")
    assert(giraffe:shout() == "Gerald shouts")

    local Dog = Animal:inherit "Dog"

    assert(Dog:getClassName() == "Dog")
    assert(Dog:getParentClass() == Animal)
    assert(Dog:isClass())
    assert(not Dog:isObject())

    local bob = Dog:new "Bob"

    assert(Animal.count == 2)
    assert(bob:getClassName() == "Dog")
    assert(bob:getClass() == Dog)
    assert(bob:isObject())
    assert(not bob:isClass())

    function Dog:shout()
        return self.name .. " barks"
    end

    assert(bob:say "gday" == "Bob says gday")
    assert(bob:shout() == "Bob barks")
end

return t
