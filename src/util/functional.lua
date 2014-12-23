-- some functional helpers: curry,

function default(value, def)
    if value == nil then
        return def
    else
        return value
    end
end

function compare(func)
    return function(a, b)
        return func(a) < func(b)
    end
end

function attr(attribute)
    return function(obj)
        return obj[attribute]
    end
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

function list(...)
    return {...}
end
pack = list

function apply(func, arguments)
    return func(unpack(arguments))
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

function filter(list, fn)
    local result = {}
    for i=1, #list do
        if fn(list[i], i) then
            table.insert(result, list[i])
        end
    end
    return result
end

function count(list, fn)
    local count = 0
    for k, v in ipairs(list) do
        if fn == nil or fn(v, k) then
            count = count + 1
        end
    end
    return count
end

-- inverse/invert
function inv(fn)
    return function(...)
        return not fn(...)
    end
end