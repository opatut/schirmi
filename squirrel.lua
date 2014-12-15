Squirrel = class('Squirrel')

function Squirrel:initialize(position)
    self.position = position
end

function Squirrel:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)

    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("fill", 0,  0, 50) -- body
    love.graphics.circle("fill", 70, 30, 30) -- head
    love.graphics.rectangle("fill", 20, 10,10,60) -- right leg
    love.graphics.rectangle("fill", - 20, 10,10,60) -- left leg

    love.graphics.pop()
end

