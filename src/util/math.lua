function lerp(t, a, b)
    return a + t * (b - a)
end

function mix(a, b, t)
    return lerp(t, a, b)
end

function apow(base, exp)
    if exp == 0 then return 1 end
    local abs = math.pow(math.abs(base), exp)
    if base == 0 then
        return 0
    elseif base < 0 then
        return - abs
    else
        return abs
    end
end

