Tree = class('Tree')

function Tree:initialize(position, z)
    self.position = position
    self.z = z
    self.seed = position.x / 191
end

function Tree:update(dt)
end

function Tree:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.scale(self.z, self.z)

    local height = Vector.Size.y / self.z
    local width = 50

    local offsets = _.range(0, -height, -10):map(function(y)
        return Vector:new(noise(self.seed + y/300) * 20, y)
    end)

    love.graphics.setColor(100 * self.z, 50 * self.z, 0)
    for i=1, #offsets-1 do
        local v = offsets[i]
        local w = offsets[i+1]
        local dx = noise(v.y/150) * 10 + 40 + math.pow(-v.y, -0.3)*100
        local ex = noise(w.y/150) * 10 + 40 + math.pow(-w.y, -0.3)*100
        love.graphics.polygon("fill", {v.x-dx, v.y, w.x-ex, w.y, w.x+ex, w.y, v.x+dx, v.y})
    end

    love.graphics.pop()
end
