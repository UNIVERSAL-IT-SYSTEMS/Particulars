local class = require "lib.middleclass"
local random = math.random --TODO change out as needed later
local floor = math.floor
local lg = love.graphics

local Particle = require "Particle"
local Double = require "Double"
local Element = require "Element"

local Universe = class("Universe")

function Universe:initialize(expansionRate, maxRadius)
    self.expansionRate = expansionRate or 1
    self.maxRadius = maxRadius or 500
    self.particles = {}
    self.doubles = {}
    self.elements = {}
    self.radius = 0
    self.time = {
        nextGeneration = random()
    }
end

function Universe:update(dt)
    if self.radius <= self.maxRadius then
        self.radius = self.radius + (self.expansionRate * dt)
    end

    self.time.nextGeneration = self.time.nextGeneration - (self.expansionRate * dt)
    if self.time.nextGeneration <= 0 then
        if Particle.static.count < Particle.static.maxCount then
            for i = 1, floor(self.radius) do
                local particle = Particle(self.radius, self.expansionRate)
                self.particles[particle] = particle
            end
        end
        self.time.nextGeneration = self.time.nextGeneration + random()
    end

    for key, particle in pairs(self.particles) do
        if Double.static.count < Double.static.maxCount then
            for key2, particle2 in pairs(self.particles) do
                if (particle:distanceTo(particle2) <= Double.static.threshold) and (particle ~= particle2) then
                    -- make a double!
                    local double = Double(particle, particle2)
                    self.doubles[double] = double
                    self.particles[key] = nil
                    self.particles[key2] = nil
                    break
                end
            end
        end

        if particle and particle:update(dt) then self.particles[key] = nil end
    end

    for key, double in pairs(self.doubles) do
        local result = double:update(dt)
        if result then
            self.doubles[key] = nil
            self.elements[result] = result
        end
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
    lg.print("Elements: " .. Element.static.count .. "/" .. Element.static.generated, 2, 26)
end

return Universe
