Squirrel = class('Squirrel')

function Squirrel:initialize(position)
    self.position = position
    self.z = 0.7
end

function Squirrel:update(dt)
    self.position.x = self.position.x + (math.abs(math.sin(Time * 4)) * 0.5 + 0.5) * dt * 200
    self.position.y = z2y(self.z) - math.abs(math.sin(Time * 4)) * 50
end

function Squirrel:draw()
    draw(self.z, function()
        love.graphics.push()
        love.graphics.translate(self.position.x - CameraOffset * self.z, self.position.y)

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle("fill", 0,  -50, 40) -- body
        love.graphics.circle("fill", 40, -70, 30) -- head
        love.graphics.rectangle("fill", -20, -60, 10, 60) -- right leg
        love.graphics.rectangle("fill",  20, -60, 10, 60) -- left leg

        love.graphics.pop()
    end)
end

