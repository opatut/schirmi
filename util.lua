function pprint(args)
    print(inspect(args))
end

function apow(base, exp)
    local abs = math.pow(math.abs(base), exp)
    if base == 0 then
        return 0
    elseif base < 0 then
        return - abs
    else
        return abs
    end
end

function z2y(z)
    return Vector.Size.y * (0.33 + z * 0.7)
end

function curry1l(f, x)
    return function(...)
        return f(x, unpack({...}))
    end
end

function curryl(f, ...)
    local curried = f
    for _, x in ipairs({...}) do
        curried = curry1l(curried, x)
    end
    return curried
end

function curry1r(f, x)
    return function(...)
        local args = {...}
        table.insert(args, x)
        return f(unpack(args))
    end
end

function curryr(f, ...)
    local curried = f
    local args = {...}
    for i=#args,1,-1 do
        curried = curry1r(curried, args[i])
    end
    return curried
end

curry = curryl

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

function meshify(outline)
    -- convert vectors to outline
    if type(outline[1]) ~= "number" and outline[1]:isInstanceOf(Vector) then
        local o = {}
        for i=1,#outline do
            outline[i]:insertInto(o)
        end
        outline = o
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


function sum(...)
    return reduce({...}, function(a, b)
        return a + b
    end)
end

function prod(...)
    return reduce({...}, function(a, b)
        return a * b
    end)
end

function map(fn, ...)
    local r = {}
    local lists = {...}
    for i=1, #(lists[0]) do
        local args = {}
        for j=1, #lists do
            table.insert(args, lists[j][i])
        end
        table.insert(r, fn(unpack(args)))
    end
    return r
end

function reduce(list, fn, default)
    local acc = default
    for k, v in ipairs(list) do
        if 1 == k and default == nil then
            acc = v
        else
            acc = fn(acc, v)
        end
    end
    return acc
end