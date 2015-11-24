local class = require "lib.middleclass"
local atan2 = math.atan2

local Double = class("Double")

Double.static.generated = 0
Double.static.count = 0

function Double:initialize(p1, p2)
    self.x = (p1.x + p2.x) / 2
    self.y = (p1.y + p2.y) / 2
    self.vx = (p1.vx + p2.vx) / 2
    self.vy = (p1.vy + p2.vy) / 2

    --self.type = ? NO TYPES (or type = p1.type + p2.type)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    self.angle = atan2(dy, dx)

    self.energy = p1.lifetime + p2.lifetime
end

function Double:update(dt)
    --TODO check if destroy or do something special

    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end

function Double:draw()
    lg.setColor(255, 55, 55, 250)
    lg.point(self.x + lg.getWidth()/2, self.y + lg.getHeight()/2)
end

return Double
