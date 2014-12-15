Tree = class('Tree')

function Tree:initialize(position)
    self.position = position
end

function Tree:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)

    local height = Vector.Size.y

    love.graphics.setColor(100, 50, 0)
    love.graphics.rectangle("fill", -25, -height, 50, height)

    love.graphics.pop()
end
