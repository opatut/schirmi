class = require 'middleclass'

require "squirrel"
require "tree"
count = 12
things = {}
x = 1
y = love.graphics.getHeight() / 2
direction = false
a = 300
font = love.graphics.newFont()
hello = "hello world!"

function love.load()
    love.window.setFullscreen(true, "desktop")
    for i = 1, count do
        tree = Tree:new(i*100, 100)
        table.insert(things, tree)
        squirrel = Squirrel:new(300, 300)
        table.insert(things,squirrel)
    end
end

function love.update(dt)
    if x > love.graphics.getWidth() - font:getWidth(hello) then
        direction = true
    elseif x <= 0 then
        direction = false
    end

    if direction then
        x = dt * (- a) + x
    else
        x = dt * a + x
    end
end

function love.keypressed()
    love.event.quit()
end
love.mousepressed = love.keypressed

function love.draw()
    love.graphics.setColor(0,255,0)
    love.graphics.print(hello, x, y)

    for i = 1, #things do
        things[i]:draw()
    end
end
