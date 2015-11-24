local class = require "lib.middleclass"
local random = math.random --TODO change out as needed later
local floor = math.floor
local pi2 = math.pi * 2
local sin = math.sin
local cos = math.cos
local sqrt = math.sqrt
local lg = love.graphics

local Particle = class("Particle")

local lifetimeRandomizer = love.math.newRandomGenerator(13) -- seeded instead of random, all types are set

Particle.static.maxLifetime = 10 --NOTE can only used fixed "randomization" as long as maxLifetime is constant (because universe is random)
Particle.static.lifetimes = {}
Particle.static.maxCount = 1000 --10000
Particle.static.generated = 0
Particle.static.count = 0

function Particle:initialize(radius, expansionRate)
    --if Particle.static.count >= Particle.static.maxCount then return nil end -- cancel over-generation of Particles

    -- this is because radius < 1 means that random() can't be used
    if not (radius > 1) then
        radius = 1
        self.x = 0
        self.y = 0
    else
        local r = random(radius)
        local d = random() * pi2
        self.x = r * cos(d)
        self.y = r * sin(d)
    end
    self.vx = random(-expansionRate, expansionRate)
    self.vy = random(-expansionRate, expansionRate)

    self.type = floor(random(radius)) -- number of types should increase over time
    if self.type > #Particle.static.lifetimes then
        for i = #Particle.static.lifetimes, self.type do
            Particle.static.lifetimes[i] = lifetimeRandomizer:random(Particle.static.maxLifetime)
        end
    end
    self.lifetime = Particle.static.lifetimes[self.type]

    Particle.static.generated = Particle.static.generated + 1
    Particle.static.count = Particle.static.count + 1
end

function Particle:update(dt)
    self.lifetime = self.lifetime - dt
    if self.lifetime <= 0 then
        Particle.static.count = Particle.static.count - 1
        return true -- true means we need to be deleted
    end

    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
end

function Particle:draw()
    lg.setColor(255, 255, 255, 200)
    lg.point(self.x + lg.getWidth()/2, self.y + lg.getHeight()/2)
end

function Particle:distanceTo(particle)
    local dx = particle.x - self.x
    local dy = particle.y - self.y
    return sqrt(dx*dx + dy*dy)
end

return Particle
