Moose = class("Moose")

function Moose:initialize(position, z)
    self.position = position
    self.z = z
    self.looking = 0
    self:startLooking()
    self.mirror = math.random() < 0.5
end

function Moose:startLooking()
    wait(math.random() * 70, function()
        tween(0.2, self, {looking=1}, "outSine", function()
            wait(lerp(math.random(), 3, 5), function()
                tween(1, self, {looking=0}, "inSine", function()
                    self:startLooking()
                end)
            end)
        end)
    end)
end


function Moose:update(dt)
    self.breath = math.sin(Time) * 0.5 + 0.5
    self.headAngle = -(math.sin(Time) * 0.5 + 0.5) * 0.2 - 1.3
    self.headAngle = lerp(self.looking, self.headAngle, 0)
end

function Moose:draw()
    parallaxDraw(self.position, self.z, function()
        love.graphics.translate(0, -220)
        love.graphics.scale(self.mirror and -1 or 1, 1)
        Color.White:set()

        local tailAngle = lerp(self.looking, -0.3*self.breath, -1)

        love.graphics.draw(mooseImages.legBR, 208, 14, 0, 1, 1, 34, 40)
        love.graphics.draw(mooseImages.legFR, 20, 55, 0, 1, 1, 33, 43)
        love.graphics.draw(mooseImages.body,  0, 0, 0, 1, 1+0.01*self.breath, 72, 84)
        love.graphics.draw(mooseImages.head,  0, 0, self.headAngle, 1, 1, 194, 320)
        love.graphics.draw(mooseImages.legBL, 242, 2, 0, 1, 1, 32, 18)
        love.graphics.draw(mooseImages.legFL, 40, 55, 0, 1, 1, 33, 43)
        love.graphics.draw(mooseImages.tail, 290, -20, tailAngle, 1, 1, 10, 10)
    end)
end
