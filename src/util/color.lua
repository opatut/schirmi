Color = class("Color")

function Color:initialize(r, g, b, a)
    self.r = (r ~= nil) and r or 1
    self.g = (g ~= nil) and g or 1
    self.b = (b ~= nil) and b or 1
    self.a = (a ~= nil) and a or 1
end

function Color:clone()
    return Color(self.r, self.g, self.b, self.a)
end

function Color:factor(x)
    return self.r * x, self.g * x, self.b * x, self.a * x
end

function Color:unpack()
    return self:factor(1)
end

function Color:set(a)
    local c = self:clone()
    if a ~= nil then c.a = c.a * a end
    c:fix()
    love.graphics.setColor(c:factor(255))
end

function Color:get()
    return Color.from255(love.graphics.getColor())
end

function Color:fix()
    self.r = math.max(0, math.min(1, self.r))
    self.g = math.max(0, math.min(1, self.g))
    self.b = math.max(0, math.min(1, self.b))
    self.a = math.max(0, math.min(1, self.a))
end

function Color:randomize(fr, fg, fb)
    if fg == nil then fg = fr end
    if fb == nil then fb = fg end
    self.r = self.r + lerp(math.random(), -fr, fr)
    self.g = self.g + lerp(math.random(), -fg, fg)
    self.b = self.b + lerp(math.random(), -fb, fb)
    self:fix()
    return self
end

function Color.__add(a, b)
    return Color:new(a.r + b.r, a.g + b.g, a.b + b.b, a.a + b.a)
end

function Color.__sub(a, b)
    return Color:new(a.r - b.r, a.g - b.g, a.b - b.b, a.a - b.a)
end

function Color.__mul(a, b)
    if type(b) == "number" then
        return Color:new(a.r * b, a.g * b, a.b * b, a.a * b)
    elseif type(a) == "number" then
        return Color:new(b.r * a, b.g * a, b.b * a, b.a * a)
    elseif b.isInstanceOf(Color) then
        return Color:new(a.r * r, a.g * b.g, a.b * b.b, a.a * b.a)
    end
end

function Color:__tostring()
    return "(" .. tonumber(self.r) .. ", " .. tonumber(self.g) .. ", " .. tonumber(self.b) .. ", " .. tonumber(self.a) .. ")"
end

function Color:lighten(f)
    local h, s, l, a = self:toHSL()
    l = math.min(1, l * (1 + f))
    return Color.fromHSL(h, s, l, a)
end

function Color:darken(f)
    return self:lighten(-f)
end

function Color:toHSL()
    local r, g, b = self.r, self.g, self.b
    local Cmax = math.max(r, g, b)
    local Cmin = math.min(r, g, b)
    local delta = Cmax - Cmin

    local h, s, l

    l = (Cmax + Cmin) / 2

    if Cmax == r then
        h = ((g - b) / delta) % 6
    elseif Cmax == g then
        h = ((b - r) / delta) + 2
    else
        h = ((r - g) / delta) + 4
    end

    h = h / 6

    if delta <= 0 then
        s = 0
    else
        s = delta / (1 - math.abs(2 * l - 1))
    end

    return h, s, l, self.a
end

function Color.static.fromHSL(h, s, l, a)
    if s <= 0 then
        return Color:new(l, l, l, a)
    end

    h = h * 6

    local c = (1 - math.abs(2 * l - 1)) * s
    local x = (1 - math.abs(h % 2 - 1)) * c
    local m = (l - 0.5 * c)
    local r, g, b

    if h < 1 then
        r,g,b = c, x, 0
    elseif h < 2 then
        r,g,b = x, c, 0
    elseif h < 3 then
        r,g,b = 0, c, x
    elseif h < 4 then
        r,g,b = 0, x, c
    elseif h < 5 then
        r,g,b = x, 0, c
    else
        r,g,b = c, 0, x
    end

    return Color:new(r + m, g + m, b + m, a)
end

function Color.static.from255(r, g, b, a)
    return Color:new(r / 255, g / 255, b / 255, (a or 255) / 255)
end

Color.static.White = Color:new(1, 1, 1)
Color.static.Transparent = Color:new(1, 1, 1, 0)
Color.static.Black = Color:new(0, 0, 0)
Color.static.Red = Color:new(1, 0, 0)
Color.static.Green = Color:new(0, 1, 0)
Color.static.Blue = Color:new(0, 0, 1)
