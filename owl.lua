Owl = class('Owl')

function Owl:initialize(position)
    self.position = position
    self.z = 1

    self.color = Color.fromHSL(math.random(), 0.9, 0.4)
    self.size = 80
    self:generate()
end

function Owl:generate()
    self.body = meshify(circle(32, function(v)
        v:apply(curryr(apow, 0.8))
        v.y = v.y - 1
        v.x = v.x * 0.8
        return v / 2
    end))

    self.belly = meshify(circle(40, function(v, i)
        if i % 2 == 0 then
            local f = lerp(v.y * 0.5 + 0.5, 0.8, 1)
            v = v:permul(Vector:new(f, f))
        end
        v.y = (v.y - 1) * 0.8
        return v * 0.6 * 0.5
    end))

    self.eye = meshify(circle(40, function(v, i)
        return v:apply(curryr(apow, 1), curryr(apow, 0.8))
    end))

    local beak = {}
    Vector:new(1, 0):insertInto(beak)
    Vector:new(0, 2):insertInto(beak)
    Vector:new(-1, 0):insertInto(beak)
    Vector:new(-0.5,-0.5):insertInto(beak)
    Vector:new(-0.0,-0.8):insertInto(beak)
    Vector:new( 0.5,-0.5):insertInto(beak)
    self.beak = meshify(beak)

    self.wing = meshify(circle(32, function(v)
        v.y = (v.y - 1) / 2
        v.x = lerp(v.y, v.x/4, v.x / 3)
        return v:rotated(math.pi)
    end))

    local ear = {}
    Vector:new(0, 0):insertInto(ear)
    Vector:new(0.2, 0.2):insertInto(ear)
    Vector:new(0, 0.5):insertInto(ear)
    self.ear = meshify(ear)
end

function Owl:update(dt)
end

function Owl:draw()
    love.graphics.push()
    love.graphics.translate(self.position.x, self.position.y)
    love.graphics.scale(self.size)

    Color:new(1, 0.8, 0):darken(0.2):set()
    love.graphics.circle("fill",  0.12, -0.03, 0.08, 32)
    love.graphics.circle("fill", -0.12, -0.03, 0.08, 32)

    -- ears
    self.color:set()
    love.graphics.draw(self.ear, -0.36, -1.1)
    love.graphics.draw(self.ear,  0.36, -1.1, 0, -1, 1)

    -- body
    self.color:set()
    love.graphics.draw(self.body, 0, 0)

    -- belly
    self.color:lighten(0.4):set()
    love.graphics.draw(self.belly, 0, 0)

    -- eye background
    self.color:lighten(0.5):set()
    love.graphics.draw(self.eye, -0.13, -0.7, 0, 0.17)
    love.graphics.draw(self.eye,  0.13, -0.7, 0, 0.17)
    Color.White:set()
    love.graphics.circle("fill", -0.13, -0.7, 0.12, 32)
    love.graphics.circle("fill",  0.13, -0.7, 0.12, 32)

    -- pupils
    Color.Black:set()
    love.graphics.circle("fill", -0.13, -0.7, 0.08, 32)
    love.graphics.circle("fill",  0.13, -0.7, 0.08, 32)
    Color.White:set()
    love.graphics.circle("fill", -0.13-0.02, -0.7-0.02, 0.02, 32)
    love.graphics.circle("fill",  0.13-0.02, -0.7-0.02, 0.02, 32)

    -- beak
    Color:new(1, 0.8, 0):darken(0.2):set()
    love.graphics.draw(self.beak, 0, -0.60, 0, 0.05)
    Color:new(1, 0.8, 0):set()
    love.graphics.draw(self.beak, 0, -0.60, 0, 0.03)

    self.color:darken(0.6):set()
    -- local spread = (Time*4)%1 > 0.5 and 0.2 or 0
    local spread = math.sin(Time*4*2*math.pi) * 0.2 + 0.2
    spread = -0.1
    love.graphics.draw(self.wing, 0.37, -0.6, -spread, 0.6)
    love.graphics.draw(self.wing,-0.37, -0.6,  spread, 0.6)

    love.graphics.pop()
end

