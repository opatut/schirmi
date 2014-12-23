BezierPoint = class("BezierPoint")

function BezierPoint:initialize(pos, before, after)
    self.pos = pos
    self.before = before
    self.after = after
end

function BezierPoint:getPos()
    return self.pos
end

function BezierPoint:getBefore()
    if self.before == nil then
        return self.pos
    elseif type(self.before) == "number" then
        return lerp(-self.before, self.pos, self.after)
    else
        return self.before
    end
end

function BezierPoint:getAfter()
    if self.after == nil then
        return self.pos
    elseif type(self.after) == "number" then
        return lerp(-self.after, self.pos, self.before)
    else
        return self.after
    end
end

------------------------------------------------------------------

function sampleSegment(from, to, samples, into, skip)
    into = default(into, {})
    samples = default(samples, 20)

    local p0 = from:getPos()
    local p1 = from:getAfter()
    local p2 = to:getBefore()
    local p3 = to:getPos()
    for i=skip,samples do
        local t = i/samples
        local t1 = 1 - t
        local v =
            1 * p0 * apow(t1, 3) * apow(t, 0) +
            3 * p1 * apow(t1, 2) * apow(t, 1) +
            3 * p2 * apow(t1, 1) * apow(t, 2) +
            1 * p3 * apow(t1, 0) * apow(t, 3)
        table.insert(into, v)
    end

    return into
end

------------------------------------------------------------------

Bezier = class("Bezier")

function Bezier:initialize()
    self.points = {}
end

function Bezier:add(pos, before, after)
    table.insert(self.points, BezierPoint:new(pos, before, after))
end

function Bezier:addRelative(pos, before, after)
    table.insert(self.points, BezierPoint:new(pos, pos + before, type(after)=="number" and after or pos + after))
end

function Bezier:outlineify(samples, loop)
    local outline = {}
    for i=1,#self.points-1 do
        sampleSegment(self.points[i], self.points[i+1], samples, outline, (i==1 and not loop) and 0 or 1)
    end
    if loop then
        sampleSegment(self.points[#self.points], self.points[1], samples, outline, 1)
    end
    return outlineify(outline)
end

function Bezier:meshify(samples, loop)
    return meshify(self:outlineify(samples, loop))
end

function Bezier:debugDraw(scale)
    scale = default(scale, 1)
    for _, point in ipairs(self.points) do
        love.graphics.setLineWidth(scale)
        local c = point:getPos()
        local b = point:getBefore()
        local a = point:getAfter()
        love.graphics.setColor(0, 0, 255)
        love.graphics.circle("line", c.x, c.y, 3*scale, 5)
        love.graphics.setColor(0, 0, 0)
        love.graphics.circle("line", b.x, b.y, 1*scale, 3)
        love.graphics.circle("line", a.x, a.y, 1*scale, 3)

        love.graphics.setColor(0, 0, 0, 100)
        love.graphics.line(a.x, a.y, c.x, c.y)
        love.graphics.line(b.x, b.y, c.x, c.y)
    end
end