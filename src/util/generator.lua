Generator = class("Generator")

function Generator:initialize(gen, rate)
    self.gen = gen
    self.rate = rate
    self.accumulator = 0

    self.items = {}
end

function Generator:update(dt)
    self.accumulator = self.accumulator + dt * self.rate
    self:generate(math.floor(self.accumulator))
    self.accumulator = self.accumulator % 1
end

function Generator:generate(n)
    for i=1,n do
        local item = self.gen()
        table.insert(self.items, item)
    end
end