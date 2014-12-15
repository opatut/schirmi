class = require 'middleclass'

require "vector"
require "squirrel"
require "tree"

treecount = 12
things = {}
font = love.graphics.newFont()

function love.load()
    love.window.setFullscreen(true, "desktop")
    Vector.Size = Vector:new(love.graphics.getWidth(), love.graphics.getHeight())

    for i = 1, treecount do
        tree = Tree:new(Vector:new(i*100, Vector.Size.y - 50))
        table.insert(things, tree)
    end

    squirrel = Squirrel:new(Vector:new(300, 300))
    table.insert(things, squirrel)
end

function love.update(dt)
end

function love.draw()
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

