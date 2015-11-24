local class = require "lib.middleclass"

local Element = class("Element")

Double.static.maxCount = 100 --1000
Double.static.generated = 0
Double.static.count = 0

function Element:initialize(double)
    -- DO SHIT BASED ON POSITIVE OR NEGATIVE
end

return Element
