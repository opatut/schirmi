-- some geometry helpers

-- dispatched drawing
local dispatched = {}
function draw(z, func)
    table.insert(dispatched, {z=z, func=func})
end
function drawDispatched()
    table.sort(dispatched, compare(attr("z")))
    for _, d in ipairs(dispatched) do
        d.func()
    end
    dispatched = {}
end

function z2y(z)
    return Vector.Size.y * lerp(math.pow(z, 2), 0.3, 1)
end

function outlineify(vectors)
    local outline = {}
    for i=1,#vectors do
        vectors[i]:insertInto(outline)
    end
    return outline
end

function meshify(vectors)
    -- convert vectors to outline
    local outline = vectors
    if type(vectors[1]) ~= "number" and vectors[1]:isInstanceOf(Vector) then
        outline = outlineify(vectors)
    end

    -- convert outline polygon to triangles
    local triangles = love.math.triangulate(outline)

    -- convert triangles to vertices
    local vertices = {}
    _.each(triangles, function(triangle)
        x1, y1, x2, y2, x3, y3 = unpack(triangle)
        table.insert(vertices, {x1, y1, x1, y1, 255, 255, 255, 255})
        table.insert(vertices, {x2, y2, x2, y2, 255, 255, 255, 255})
        table.insert(vertices, {x3, y3, x3, y3, 255, 255, 255, 255})
    end)

    -- make a mesh out of you
    return love.graphics.newMesh(vertices, nil, "triangles")
end

function circle(steps, fn)
    local points = {}
    local step = math.pi * 2 / steps
    for i = 0, steps - 1 do
        local alpha = i * step
        local v = Vector:new(math.sin(alpha), math.cos(alpha))
        if fn then
            v = fn(v, i)
        end
        table.insert(points, v)
    end
    return points
end

function parallax(position, depth, fn)
    love.graphics.push()
    love.graphics.translate(position.x - CameraOffset * depth, position.y)
    love.graphics.scale(scaleDepth(depth))

    fn()

    love.graphics.pop()
end

function parallaxDraw(position, depth, fn)
    draw(depth, curry(parallax, position, depth, fn))
end

function scaleDepth(depth)
    return lerp(depth, 0.1, 1)
end