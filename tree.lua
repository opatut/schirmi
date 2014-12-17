Tree = class('Tree')

function Tree:initialize(position, z)
    self.position = position
    self.z = z
    self.seed = math.random()

    self.mesh = nil
    self.width = math.random() * 40 + 20
    self:generate()
end

function Tree:generate()
    local rotation = math.pi
    local length = (self.position.y + 50) / self.z
    local width = self.width
    local outline = {}

    local offsets = _.range(1, length, width / 2):map(function(y)
        return Vector:new(noise(self.seed + y/300) * 20, y)
    end)

    for i=1, #offsets do
        local v = (offsets[i] + Vector:new((noise(offsets[i].y/150) * 0.25 + 1) * width, 0)):rotated(rotation)
        table.insert(outline, v.x)
        table.insert(outline, v.y)
    end

    for i=#offsets, 1, -1 do
        local v = (offsets[i] - Vector:new((noise(offsets[i].y/150) * 0.25 + 1) * width, 0)):rotated(rotation)
        table.insert(outline, v.x)
        table.insert(outline, v.y)
    end

    -- generate outline
    self.outline = outline
    self.mesh = meshify(outline)
end

function Tree:update(dt)
end

function Tree:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x - CameraOffset * self.z, self.position.y)
    love.graphics.scale(self.z, self.z)

    love.graphics.setColor(100 * self.z, 50 * self.z, 0)
    local f = math.pow(1 - self.z, 2)
    love.graphics.setColor(80 + f*155, 40 + f*185, f*150)
    love.graphics.draw(self.mesh, 0, 0)
    -- love.graphics.polygon("line", self.outline)

    love.graphics.pop()
end
