local atan2 = math.atan2
local sin = math.sin
local cos = math.cos
local pi = math.pi
local lg = love.graphics
local sw = lg.getWidth()/2
local sh = lg.getHeight()/2
local set = setmetatable

local Element = require "Element"

local Double = {}

Double.static = {}
Double.static.threshold = 0.06
Double.static.maxCount = 5000 --5000
Double.static.generated = 0
Double.static.count = 0

function Double.initialize(p1, p2)
    --if Double.static.count >= Double.static.maxCount then return nil end -- cancel over-generation

    local self = {}
    set(self, {__index = Double})

    self.x = (p1.x + p2.x) / 2
    self.y = (p1.y + p2.y) / 2
    self.vx = (p1.vx + p2.vx) / 2
    self.vy = (p1.vy + p2.vy) / 2

    --self.type = ? NO TYPES (or type = p1.type + p2.type)
    local dx = p2.x - p1.x
    local dy = p2.y - p1.y
    self.angle = atan2(dy, dx)

    self.energy = p1.lifetime + p2.lifetime

    Double.static.generated = Double.static.generated + 1
    Double.static.count = Double.static.count + 1

    return self
end

function Double:update(dt)
    -- if energy too high / too low, make an Element
    if (self.energy >= 10) or (self.energy <= -20) then
        return Element.initialize(self)
    end

    self.energy = self.energy - dt/10

    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
    self.angle = self.angle + (self.energy * dt)
end

function Double:draw()
    lg.setColor(255, 55, 55, 250)

    local x = self.x + (1 * cos(self.angle))
    local y = self.y + (1 * sin(self.angle))
    lg.point(x + sw, y + sh)

    local x = self.x + (1 * cos(self.angle + pi))
    local y = self.y + (1 * sin(self.angle + pi))
    lg.point(x + sw, y + sh)
end

return Double
