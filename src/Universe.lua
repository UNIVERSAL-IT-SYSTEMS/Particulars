local class = require "lib.middleclass"
local random = math.random --TODO change out as needed later
local lg = love.graphics
local Particle = require "Particle"

local Universe = class("Universe")

function Universe:initialize(expansionRate)
    self.expansionRate = expansionRate or 1
    self.particles = {}
    self.radius = 0 --2
    self.time = {
        nextGeneration = random()
    }
end

function Universe:update(dt)
    self.radius = self.radius + (self.expansionRate * dt)

    self.time.nextGeneration = self.time.nextGeneration - (self.expansionRate * dt)
    while self.time.nextGeneration <= 0 do
        --TODO make amount spawned modified by radius ?
        local particle = Particle(self.radius, self.expansionRate)
        self.particles[particle] = particle
        self.time.nextGeneration = self.time.nextGeneration + random()
    end

    for key, particle in pairs(self.particles) do
        --print(key, particle) --debug
        particle.lifetime = particle.lifetime - dt
        if particle.lifetime <= 0 then
            self.particles[key] = nil
        else
            particle:update(dt)
        end
    end
end

function Universe:draw()
    for _, particle in pairs(self.particles) do
        particle:draw()
    end

    lg.circle("line", lg.getWidth()/2, lg.getHeight()/2, self.radius)
end

return Universe
