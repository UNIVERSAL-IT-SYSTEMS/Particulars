local class = require "lib.middleclass"
local random = math.random --TODO change out as needed later
local floor = math.floor
local lg = love.graphics

local Particle = class("Particle")

local lifetimeRandomizer = love.math.newRandomGenerator(13--[[os.time()]])
local maxLifetime = 10 --NOTE can only used fixed "randomization" as long as maxLifetime is constant ?
local lifetimes = {}

function Particle:initialize(radius, expansionRate)
    --NOTE radius is used as a box, not an actual radius...
    --TODO FIX THIS IMMEDIATEITGJE

    if not (radius > 1) then radius = 1 end -- stop randomization errors

    self.x = random(-radius, radius)
    self.y = random(-radius, radius)
    self.vx = random(-expansionRate, expansionRate) --TODO make max velocity change based on radius??
    self.vy = random(-expansionRate, expansionRate)

    self.type = floor(random(radius)) -- number of types should increase over time
    if self.type > #lifetimes then
        for i = #lifetimes, self.type do
            lifetimes[i] = lifetimeRandomizer:random(maxLifetime)
        end
    end
    self.lifetime = lifetimes[self.type]

    --[[ debug
    for k,v in pairs(lifetimes) do
        print(k,v)
    end
    print(self.lifetime)
    ]]
end

function Particle:update(dt)
    self.x = self.x + (self.vx * dt)
    self.y = self.y + (self.vy * dt)
    --TODO shouldn't this update its life and set self nil here??
end

function Particle:draw()
    lg.point(self.x + lg.getWidth()/2, self.y + lg.getHeight()/2)
    --lg.circle("fill", self.x + lg.getWidth()/2, self.y + lg.getHeight()/2, 1)
end

return Particle
