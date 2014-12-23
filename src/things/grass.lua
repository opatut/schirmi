Grass = class('Grass')

function Grass:initialize(position, z, color)
    self.position = position
    self.color = color
    self.z = z
    self:generate()
end

function Grass:generate()
    self.bezier = Bezier:new()

    local tip  = Vector:new(lerp(math.random(), -1, 1) * 0.5, lerp(math.random(), -1, -1.2))
    local offset = Vector:new(0.2, 0)

    self.bezier:addRelative(-offset, offset/2, Vector:new( 0.1, -0.4))
    self.bezier:addRelative(tip, (-tip):rotated( 0.2) * 0.4, (-tip):rotated(-0.2) * 0.4)
    self.bezier:addRelative( offset, Vector:new(-0.1, -0.4), -offset/2)

    self.mesh = self.bezier:meshify(1, false)
end

function Grass:update(dt)
    self.dead = (self.position.x - CameraOffset * self.z < - 20)
end

function Grass:draw()
    draw(self.z+0.001, function()
        parallax(self.position, self.z, function()
            self.color:set()
            love.graphics.scale(80)
            love.graphics.draw(self.mesh, 0, 0, 0, 0.6)
        end)
    end)
end
