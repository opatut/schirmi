Leaves = class('Leaves')

function Leaves:initialize(tree, position, size)
    self.tree = tree
    self.position = position
    self.size = size
    self.seed = math.random()

    local h, s, l = tree.leafColor:toHSL()
    self.color = fogify(self.tree.z, Color.fromHSL(h, s, l + lerp(math.random(), -0.1, 0.1)))


    self:generate()
end

function Leaves:generate()
    while true do
        self.bezier = Bezier:new()
        self.bezier.points = circle(16, function(v, i)
            v = v * lerp(math.random(), 1.0, 1.3)
            v = v:permul(self.size/2)
            return BezierPoint:new(v, v + v:rotated(math.pi/2) * 0.1, 1)
        end)

        success, self.mesh = pcall(Bezier.meshify, self.bezier, 4, true)
        if success then break end
    end
end

function Leaves:draw()
    draw(self.tree.z + 0.01 * (1+self.seed), function()
        parallax(self.position, self.tree.z, function()
            self.color:set(debug and 0.5 or 0.9)
            love.graphics.draw(self.mesh)
            if debug then
                Color.Black:set()
                love.graphics.rectangle('line', - self.size.x/2, - self.size.y / 2, self.size.x, self.size.y)
            end
        end)
    end)
end

-----------------------------------------------------------------------------------------------

Branch = class('Branch')

function Branch:initialize(parent, tree, length, order, offset, angle, thickness)
    self.parent = parent
    self.tree = tree
    self.length = length
    self.offset = offset
    self.order = order
    self.angle = angle
    self.thickness = thickness
    self.children = {}
    self.owl = nil
end

function Branch:generateChildren(levels)
    if math.random() < 0.2 and
            self.tree.z > 0.4 and
            math.abs(self:getAngle()) > 1.2 then
        self.owl = Owl:new(self.tree.position - Vector:new(0, self.thickness/2) + (self:getRoot() + 0.5 * self:getDirection())*scaleDepth(self.tree.z), self.tree.z)
    end
    if levels > 0 then
        local firstAngle = 0

        for i=1,2 do --+math.random()*2 do
            local ang = math.random()

            local length = lerp(math.random(), 0.8, 1.0)* self.length
            local order = i == 1 and 0.5 or ang
            local offset = i == 1 and 1 or lerp(1 - math.abs(lerp(ang, 0, 2) - 1), 0.4, 1)
            local angle = math.min(self.angle + 0.8, math.max(self.angle - 0.8, lerp(ang, -1.4, 1.4)))
            local thickness = lerp(math.random(), 0.3, 0.6) * self.thickness

            if i == 1 then
                firstAngle = angle
            elseif ang < 0.5 then
                angle = math.min(angle, firstAngle - 0.1)
            elseif ang > 0.5 then
                angle = math.max(angle, firstAngle + 0.1)
            end

            local child = Branch:new(self, self.tree, length, order, offset, angle, thickness)
            table.insert(self.children, child)
            child:generateChildren(levels - 1)
        end
        table.sort(self.children, compare(attr("order")))
    else
        table.insert(self.tree.tips, self:getTip())
    end
end

function Branch:getDirection()
    return Vector:new(0, -self:getLength()):rotated(self:getAngle())
end

function Branch:getLength()
    return self.length
end

function Branch:getAngle()
    return self.angle
end

function Branch:getRoot()
    if self.parent then
        return self.parent:getRoot() + self.parent:getDirection() * self.offset
    else
        return Vector:new(0, 0)
    end
end

function Branch:getTip()
    return self:getRoot() + self:getDirection()
end

function Branch:draw()
    if debug then
        love.graphics.setLineWidth(2)
        local r = self:getRoot()
        local t = self:getTip()
        Color.Red:set()
        love.graphics.line(r.x, r.y, t.x, t.y)
    end

    if self.owl then
        self.owl:draw()
    end

    for i=1,#self.children do
        self.children[i]:draw()
    end
end

function Branch:addToBezier(bezier)
    local r = self:getRoot()
    local t = self:getTip()
    local d = self:getDirection() * 0.3

    local m = (self.parent == nil) and r or lerp(0.3, r, t)
    local w = Vector(self.thickness / 2, 0):rotated(self:getAngle())
    bezier:addRelative(m - w, -d, 1)

    if #self.children == 0 then
        bezier:add(t, t - w/2, t + w/2)
    else
        for i=1,#self.children do
            if i > 1 then
                bezier:add(lerp(0.5,
                    self.children[i-1]:getRoot() + self.children[i-1]:getDirection() * 0.1,
                    self.children[i  ]:getRoot() + self.children[i  ]:getDirection() * 0.1))
            end
            self.children[i]:addToBezier(bezier)
        end
    end

    bezier:addRelative(m + w, d, 1)
end

-----------------------------------------------------------------------------------------------

Tree = class('Tree')

function Tree:initialize(position, z)
    self.position = position
    self.z = z
    self.seed = math.random()
    -- self.color = Color.fromHSL(0.1, lerp(math.random(), 0.5, 0.7), lerp(math.random(), 0.2, 0.3))
    self.color = fogify(self.z, Color.from255(100, 50, 0))

    self.width = math.random() * 40 + 20
    self.leaves = {}
    self.tips = {}

    -- self.leafColor = randomChoice({Color.from255(150, 157, 31), Color.from255(155, 99, 31)})
    self.leafColor = Color.from255(150, 157, 31)

    self:generate()
end

function Tree:generate()
    local width = Vector.Size.y / 7.2

    while true do
        self.tips = {}
        self.mainBranch = Branch:new(nil, self, lerp(math.random(), 0.5, 1) * 4 * width, 0, 0, 0, width)
        self.mainBranch:generateChildren(3)

        self.bezier = Bezier:new()
        self.mainBranch:addToBezier(self.bezier)
        -- self.outline = self.bezier:outlineify(20, false)
        success, self.mesh = pcall(Bezier.meshify, self.bezier, 4, false)
        if success then break end
    end

    -- 90% leafless trees
    if math.random() < 0.9 then
        -- find tip extents
        local extents = reduce(self.tips, function(r, v)
            r.left = math.min(r.left, v.x)
            r.top = math.min(r.top, v.y)
            r.right = math.max(r.right, v.x)
            r.bottom = math.max(r.bottom, v.y)
            return r
        end, {left=math.huge, right=-math.huge, top=math.huge, bottom=-math.huge})

        local center = Vector:new(lerp(0.5, extents.left, extents.right), lerp(0.5, extents.top, extents.bottom))
        center = center * scaleDepth(self.z)
        local size = Vector:new(math.abs(extents.right - extents.left), math.abs(extents.bottom - extents.top))
        table.insert(self.leaves, Leaves:new(self, self.position + center, size))
    end

    -- grass at the root
    local grassColor = groundColor(self.z)
    for i=0,1,lerp(self.z, 0.2, 0.1) do
        local dx = lerp(i, -1, 1) * width * 0.5 * scaleDepth(self.z)
        table.insert(things, Grass:new(self.position + Vector(dx, 0), self.z, grassColor))
    end
end

function Tree:update(dt)
    self.dead = (self.position.x - CameraOffset * self.z < - Vector.Size.x/2)
end

function Tree:draw()
    if debug then
        self.mainBranch:draw()
    end

    parallaxDraw(self.position, self.z, function()
        self.color:set()
        love.graphics.draw(self.mesh)

        if debug then
            for _, tip in ipairs(self.tips) do
                love.graphics.circle("fill", tip.x, tip.y, 10)
            end
        end
    end)

    self.mainBranch:draw()

    for _, leaves in ipairs(self.leaves) do
        leaves:draw()
    end
end

