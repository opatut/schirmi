Sun = class("Sun")

function Sun:initialize()
    self.img = love.graphics.newImage("data/sun.png")
end

function Sun:update(dt)
end

function Sun:draw()
    draw(0, function()
        love.graphics.push()
        love.graphics.translate(Vector.Size.x * 0.3, Vector.Size.y * 0.15)
        love.graphics.scale(Vector.Size.x * 0.2 / 512)

        love.graphics.setColor(255, 255, 200)
        love.graphics.draw(self.img, -256, -256)

        love.graphics.pop()
    end)
end
