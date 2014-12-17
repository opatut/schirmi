Grass = class('Grass')

function Grass:initialize(x, ground)
    self.x = x
    self.ground = ground
    self.z = ground.z
    self:generate()
end

function Grass:generate()
    self.y = self.ground:getHeight(self.x)

    local root = Vector:new(0, 0)
    -- local tip = Vector:new(lerp(math.random(), -5, 5), lerp(math.random(), -20, -30))
    local step = Vector:new(0, lerp(math.random(), -6, -12))
    local rotSeed = math.random()
    local angle = 0
    local width = -step.y

    local c = root

    local vertices = {}
    for i=0,1,0.1 do
        local o = (1 - i) * Vector:new(0, 1):rotated(math.pi/2) * lerp(noise(i + self.x/1000) + 0.5, 1, 2) * width
        table.insert(vertices, {c.x + o.x, c.y + o.y})
        table.insert(vertices, {c.x - o.x, c.y - o.y})

        local rotation = lerp(rotSeed + i * 0.1, -1, 1) * 0.1
        angle = angle + rotation
        c = c + step:rotated(angle)
    end

    self.mesh = love.graphics.newMesh(vertices, nil, "strip")
end

function Grass:update(dt)
end

function Grass:draw()
    love.graphics.push()
    love.graphics.translate(self.x - CameraOffset * self.z, self.y + 5)
    love.graphics.scale(self.z)

    self.ground.    color:set()
    love.graphics.draw(self.mesh, 0, 0)

    love.graphics.pop()
end
