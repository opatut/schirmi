function pprint(args)
    print(inspect(args))
end

function wait(time, callback)
    return tween(time, {}, {}, "linear", callback)
end

function randomChoice(xs)
    return xs[math.ceil(math.random() * #xs)]
end

function fogify(z, color)
    return lerp(1 - 0.5 * apow(1 - z, 2), Fog, color)
end