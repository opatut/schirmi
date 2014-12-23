Conifer = class('Conifer')

function Conifer:initialize(position, z)
    self.position = position
    self.z = z
    self.rot = lerp(math.random(), -0.2, 0.2)
    self.seed = math.random()
    self.size = 300

    self.color = fogify(self.z, Color.from255(30, 60, 10))
    self.color = fogify(self.z, Color.from255(30, 60, 10))

    self.mesh = nil
    self.width = math.random() * 40 + 20
    self:generate()
end

function Conifer:generate()
    self.bezier = Bezier:new()
    self.bezier:add(Vector:new( 0.0, 0.0), Vector:new(-0.2, 0.5), Vector:new( 0.2, 0.5))
    self.bezier:add(Vector:new( 0.7, 1.0), Vector:new( 0.3, 0.7), Vector:new( 0.2, 1.2))
    self.bezier:add(Vector:new(-0.7, 1.0), Vector:new(-0.2, 1.2), Vector:new(-0.3, 0.7))
    self.mesh = self.bezier:meshify(10, true)
end

function Conifer:update(dt)
    self.dead = (self.position.x - CameraOffset * self.z < - Vector.Size.x/2)
end

function Conifer:draw()
    parallaxDraw(self.position, self.z, function()
        love.graphics.translate(0, - self.size * scaleDepth(self.z))
        love.graphics.scale(self.size)

        for y=0,1,0.2 do
            lerp(lerp(y, 0.5, 1), Color.Black, self.color):set()
            for i=0,1,0.4 do
                love.graphics.draw(self.mesh, 0, -y*2-0.5, 0, (1-y)*lerp(i, 1.4, 0.6), lerp(i, 1, 0.4))
            end
        end
    end)
end
