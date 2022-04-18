local Class = require "class"

local t = {}

function t:all()
    local Animal = Class{name = "Animal"}

    function Animal:new(name)
        self.name = name
        Animal.count = (Animal.count or 0) + 1
    end
    
    assert(Animal.count == nil)

    local giraffe = Animal("Gerald")

    assert(Animal.count == 1)
    assert(giraffe.name == "Gerald")
    
    function Animal:say(sth)
        return self.name .. " says " .. sth
    end
    
    function Animal:knowsMath()
        return false
    end

    assert(giraffe:say("hi") == "Gerald says hi")
    assert(giraffe:knowsMath() == false)

    local Dog = Class{name = "Dog", parent = Animal}

    local bob = Dog("Bob")

    assert(Animal.count == 2)
    assert(bob.name == "Bob")

    function Dog:say(sth)
        return self.name .. " barks"
    end

    assert(bob:say("hi") == "Bob barks")
    assert(bob:knowsMath() == false)
end

return t
