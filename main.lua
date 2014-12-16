class = require 'middleclass'
noise = require 'noise'
_ = require 'underscore'

require "vector"
require "squirrel"
require "tree"

treecount = 20
things = {}
Time = 0
font = love.graphics.newFont()

function love.load()
    love.window.setFullscreen(true, "desktop")
    Vector.Size = Vector:new(love.graphics.getWidth(), love.graphics.getHeight())
    math.randomseed(os.time())

    floor = love.graphics.newImage("data/floor.png")

    for i = 1, treecount do
        local d = 0.2 + math.pow(math.random(), 2) * 0.8
        tree = Tree:new(Vector:new(Vector.Size.x * math.random(), Vector.Size.y * (0.33 + d * 0.7)), d)
        table.insert(things, tree)
    end

    squirrel = Squirrel:new(Vector:new(300, 300))
    table.insert(things, squirrel)
end

function love.update(dt)
    Time = Time + dt

    for i = 1, #things do
        things[i]:update(dt)
    end
end

function love.draw()
    table.sort(things, function(a, b) return a.z < b.z end)

    love.graphics.setBackgroundColor(100, 200, 255)
    love.graphics.setColor(255, 200, 200)
    love.graphics.draw(floor, 0, Vector.Size.y * 0.33)
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

