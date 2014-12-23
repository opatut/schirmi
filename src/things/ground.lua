Ground = class('Ground')

function Ground:initialize(y, z, color)
    self.y = y
    self.z = z
    self.color = color
    self.seed = math.random() * 100
    self.perlin = perlin(3, 0.4, 1.71)
    self:generate()
end

function Ground:getHeight(x)
    -- return self.y
    return self.y - (1.1 + self.perlin(self.seed + x/1000) * Vector.Size.y * self.z) * 0.2
end

function Ground:generate()
    -- generate outline
    local outline = {}
    local p = 10
    for x=-p, Vector.Size.x+p, 20 do
        table.insert(outline, x)
        table.insert(outline, self:getHeight(CameraOffset * self.z + x))
    end
    table.insert(outline, Vector.Size.x + p)
    table.insert(outline, Vector.Size.y * 2 + p)
    table.insert(outline, - p)
    table.insert(outline, Vector.Size.y * 2 + p)
    self.outline = outline

    -- convert outline polygon to triangles
    local triangles = love.math.triangulate(outline)

    -- convert triangles to vertices
    local vertices = {}
    _.each(triangles, function(triangle)
        local x1, y1, x2, y2, x3, y3 = unpack(triangle)
        table.insert(vertices, {x1, y1, x1, y1, 255, 255, 255, 255})
        table.insert(vertices, {x2, y2, x2, y2, 255, 255, 255, 255})
        table.insert(vertices, {x3, y3, x3, y3, 255, 255, 255, 255})
    end)

    self.mesh = love.graphics.newMesh(vertices, nil, "triangles")
end

function Ground:update(dt)
    self:generate()
end

function Ground:draw()
    draw(self.z, function()
        self.color:set()
        love.graphics.draw(self.mesh, 0, 0)
    end)
end
