Squirrel = class('Squirrel')

function Squirrel:initialize(x, y)
    self.x = x
    self.y = y
end

function Squirrel:draw()
    love.graphics.circle("fill", self.x,self.y,50)
    love.graphics.circle("fill",self.x + 70,self.y - 30,30)
    love.graphics.rectangle("fill",self.x + 20,self.y + 10,10,60)
    love.graphics.rectangle("fill",self.x - 20,self.y + 10,10,60)
end

