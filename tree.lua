
Tree = class('Tree')

function Tree:initialize(x , y)
    self.x = x
    self.y = y
end

function Tree:draw ()
    love.graphics.setColor(100,50,0)
    love.graphics.rectangle("fill", self.x, self.y, 50,100)
end