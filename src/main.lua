local lg = love.graphics
local lm = love.math
--NOTE math.random seed has not been set, this means every run should be the same (except for potential hardware differences)

local Universe = require "Universe"
--local Particle = require "Particle"

local universe = Universe()

function love.update(dt)
    universe:update(dt)
end

function love.draw()
    universe:draw()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
