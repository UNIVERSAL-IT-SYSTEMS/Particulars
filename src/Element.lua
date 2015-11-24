local class = require "lib.middleclass"

local Element = class("Element")

Element.static.maxCount = 100 --1000
Element.static.generated = 0
Element.static.count = 0

function Element:initialize(double)
    -- DO SHIT BASED ON POSITIVE OR NEGATIVE
end

return Element
