class = require 'middleclass'
n = require 'noise'
noise = n.noise
perlin = n.perlin
inspect = require 'inspect'
_ = require 'underscore'

require "util"
require "gradient"
require "vector"
require "squirrel"
require "tree"
require "grass"
require "ground"
require "owl"
require "color"

treecount = 0
things = {}
Time = 0
CameraOffset = 0
font = love.graphics.newFont()
sky = gradient({{232, 233, 115}, {200, 233, 170}, direction="horizontal"})

function love.load()
    -- love.window.setFullscreen(true, "desktop")
    love.window.setMode(1200, 800)
    Vector.Size = Vector:new(love.graphics.getWidth(), love.graphics.getHeight())
    math.randomseed(os.time())

    floor = love.graphics.newImage("data/floor.png")

    for i = 1, treecount do
        local z = 0.2 + math.pow(math.random(), 7) * 0.8
        tree = Tree:new(Vector:new(Vector.Size.x * math.random(), z2y(z)), z)
        table.insert(things, tree)
    end

    local groundColors = {
        Color.from255(154, 157, 51),
        Color.from255(89, 105, 40)
    }
    for i = 1, #groundColors do
        local z = 0.7 - i * 0.2
        local ground = Ground:new(z2y(z), z, groundColors[i])
        table.insert(things, ground)

        for i = 0, Vector.Size.y do
            table.insert(things, Grass:new((i - i % 3) * 20 + i%17, ground))
        end
    end

    table.insert(things, Owl:new(Vector.Size / 2))


    squirrel = Squirrel:new(Vector:new(300, 300))
    table.insert(things, squirrel)
end

function love.update(dt)
    Time = Time + dt

    for i = 1, #things do
        things[i]:update(dt)
    end

    CameraOffset = Time * 50
end

function love.draw()
    table.sort(things, function(a, b) return a.z < b.z end)

    love.graphics.setColor(255, 255, 255)
    draw_rect(sky, 0, 0, Vector.Size.x, Vector.Size.y)

    -- love.graphics.setBackgroundColor(100, 200, 255)
    -- love.graphics.setBackgroundColor(223, 234, 134)
    -- love.graphics.setColor(255, 200, 200)
    -- love.graphics.draw(floor, 0, Vector.Size.y * 0.33)
    -- love.graphics.setColor(50, 100, 0)
    -- love.graphics.rectangle("fill", 0, Vector.Size.y * 0.33, Vector.Size.x, Vector.Size.y)
    for i = 1, #things do
        things[i]:draw()
    end
end

-- Event handling

function love.keypressed()
    love.event.quit()
end

function love.mousepressed()
    love.event.quit()
end

