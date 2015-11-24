local class = require "lib.middleclass"
local random = math.random --TODO change out as needed later
local floor = math.floor
local lg = love.graphics

local Particle = require "Particle"
local Double = require "Double"

local Universe = class("Universe")

function Universe:initialize(expansionRate)
    self.expansionRate = expansionRate or 1
    self.particles = {}
    self.doubles = {}
    self.radius = 0
    self.time = {
        nextGeneration = random()
    }
end

function Universe:update(dt)
    self.radius = self.radius + (self.expansionRate * dt)

    self.time.nextGeneration = self.time.nextGeneration - (self.expansionRate * dt)
    while self.time.nextGeneration <= 0 do
        for i = 1, floor(self.radius) do
            local particle = Particle(self.radius, self.expansionRate)
            self.particles[particle] = particle
        end
        self.time.nextGeneration = self.time.nextGeneration + random()
    end

    for key, particle in pairs(self.particles) do
        if particle:update(dt) then self.particles[key] = nil end
    end
    for key, double in pairs(self.doubles) do
        if double:update(dt) then self.doubles[key] = nil end
    end
end

function Universe:draw()
    for _, particle in pairs(self.particles) do
        particle:draw()
    end
    for _, double in pairs(self.doubles) do
        double:draw()
    end

    lg.setColor(255, 255, 255, 50)
    lg.circle("line", lg.getWidth()/2, lg.getHeight()/2, self.radius)
    lg.setColor(255, 255, 255, 255)
    lg.print("Particles: " .. Particle.static.count .. "/" .. Particle.static.generated, 2, 2)
    lg.print("Doubles: " .. Double.static.count .. "/" .. Double.static.generated, 2, 14)
end

return Universe
