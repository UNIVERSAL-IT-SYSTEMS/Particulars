local lg = love.graphics
local lm = love.math

local particularRandomization = lm.newRandomGenerator(os.time())
local currentMaxPosition = 2
local maxVelocity = 2
local lifetimes = {}
local particularLifetimes = lm.newRandomGenerator(os.time()*2)
local currentMaxType = 2
local maxLifetime = 10

local function particular()
    local self = {}

    self.x = particularRandomization:random(currentMaxPosition)
    self.y = particularRandomization:random(currentMaxPosition)
    self.vx = particularRandomization:random(maxVelocity)
    self.vy = particularRandomization:random(maxVelocity)

    self.type = particularRandomization:random(currentMaxType)
    if self.type > #lifetimes then
        for i=#lifetimes,self.type do
            lifetimes[i] = particularLifetimes:random(maxLifetime)
        end
    end
    self.lifetime = lifetimes[self.type]

    return self
end

local particles = {}

local generationTiming = lm.newRandomGenerator(os.time()+100)
local nextGeneration = generationTiming:random()
local generationTimingCurrentTime = 0

local maxTypeIncrementTimer = 0
local maxTypeIncrementInterval = 100
function love.update(dt)
    currentMaxPosition = currentMaxPosition + dt

    maxTypeIncrementTimer = maxTypeIncrementTimer + dt
    while maxTypeIncrementTimer >= maxTypeIncrementInterval do
        maxTypeIncrementTimer = maxTypeIncrementTimer - maxTypeIncrementInterval
        currentMaxType = currentMaxType + 1
    end

    generationTimingCurrentTime = generationTimingCurrentTime + dt
    while generationTimingCurrentTime >= nextGeneration do
        generationTimingCurrentTime = generationTimingCurrentTime - nextGeneration
        nextGeneration = generationTiming:random()
        table.insert(particles, particular())
    end

    local deletes = {}
    --for i=1
    for k, p in pairs(particles) do
        p.x = p.vx * dt
        p.y = p.vy * dt
        p.lifetime = p.lifetime - dt
        if p.lifetime <= 0 then
            table.insert(deletes, k)
        end
    end
    for _, p in ipairs(deletes) do
        particles[p] = nil
    end
end

--lg.setColor(255, 255, 255, 255)
function love.draw()
    --for i=1,#particles do
    --    lg.point(particles[i].x, particles[i].y)
    --end
    for _, p in pairs(particles) do
        --lg.point(p.x, p.y)
        lg.circle("fill", p.x, p.y, 1)
    end

    lg.circle("line", lg.getWidth()/2, lg.getHeight()/2, currentMaxPosition)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end
