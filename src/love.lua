treecount = 20
things = {}
Time = 0
CameraOffset = 0
font = love.graphics.newFont()
-- sky = gradient({{232, 233, 115}, {200, 233, 170}, direction="horizontal"})
sky = gradient({{100, 180, 255}, {200, 220, 255}, direction="horizontal"})

-- Fog = Color.from255(232, 233, 115)
Fog = Color.from255(200, 220, 255)

debug = false
paused = false
preloadDuration = 100
preloading = debug and 0 or preloadDuration
font = nil
release = true

mouse = nil

preloadTexts = {
    "Planting trees",
    "Mowing the lawn",
    "Growing flowers",
    "Releasing birds",
    "Scattering clouds",
    "Raking leaves",
    "Preparing weather"
}

treegen = Generator:new(function()
    local z = lerp(math.pow(math.random(), 10), 0.1, 0.9)

    local Cls = Tree
    if math.random() < 0.4 then
        Cls = Conifer
    end
    tree = Cls:new(Vector:new(CameraOffset / z + Vector.Size.x * lerp(math.random(), 1, 1.5), z2y(z)), z)

    table.insert(things, tree)
    return tree
end, 5)

moosegen = Generator:new(function()
    local z = lerp(math.random(), 0.7, 0.9)
    local moose = Moose:new(Vector:new(CameraOffset + Vector.Size.x * lerp(math.random(), 1, 1.5), z2y(z)), z)

    table.insert(things, moose)
    return moose
end, 1/120)

grounds = {}

function groundColor(z)
    for _, ground in ipairs(grounds) do
        if ground.z < z then
            return ground.color
        end
    end
    return Color.White
end

grassgen = Generator:new(function()
    local ground = grounds[math.ceil(lerp(math.random(), 0, 2))]

    local x = CameraOffset / ground.z + Vector.Size.x + lerp(math.random(), 20, 40)
    local grass = Grass:new(Vector:new(x, ground:getHeight(x) + 5), ground.z, ground.color)

    table.insert(things, grass)
    return grass
end, 5)

function love.load()
    love.keyboard.setKeyRepeat(true)
    love.window.setFullscreen(true, "desktop")
    font = love.graphics.newFont("data/TrashHand.TTF", 30)
    huge = love.graphics.newFont("data/TrashHand.TTF", 60)
    love.graphics.setFont(font)


    mooseKeys = {"body", "head", "legBL", "legBR", "legFL", "legFR", "tail"}
    mooseImages = {}

    for _, key in ipairs(mooseKeys) do
        mooseImages[key] = love.graphics.newImage("data/moose/" .. key .. ".png")
    end


    -- love.window.setMode(1200, 800)
    Vector.Size = Vector:new(love.graphics.getWidth(), love.graphics.getHeight())
    math.randomseed(os.time())

    -- create ground layers
    for i = 0, 1, 0.2 do
        local z = lerp(i, 0.8, 0)
        local color = lerp(1-i, Color.from255(89, 105, 40), Color.from255(154, 157, 51))

        local ground = Ground:new(z2y(z), z, color)
        table.insert(things, ground)
        table.insert(grounds, ground)
    end

    -- if not debug then
    --     local dt = 0.2
    --     for i=0,100,dt do
    --         love.update(dt)
    --     end
    -- end

    table.insert(things, Sun:new())
end

function love.update(dt)
    if preloading > 0 then
        dt = 0.3
        preloading = preloading - dt
    elseif release then
        if not mouse then
            mouse = Vector:new(love.mouse.getPosition())
        else
            newmouse = Vector:new(love.mouse.getPosition())
            if newmouse ~= mouse then
                love.event.quit()
            end
        end
    end

    tween.update(dt)

    if love.keyboard.isDown("left") then
        dt = dt * -10
    elseif love.keyboard.isDown("right") then
        dt = dt * 10
    end
    Time = Time + dt

    -- filter dead stuff
    things = filter(things, inv(attr("dead")))

    if not paused then
        treegen:update(dt)
        grassgen:update(dt)
        moosegen:update(dt)
    end

    for i = 1, #things do
        things[i]:update(dt)
    end

    if not paused then
        local speed = 50
        CameraOffset = CameraOffset + dt * speed
    end
end

function love.draw()
    if preloading > 0 then
        Color.White:set()
        local p = 1 - preloading / preloadDuration

        local progress = tostring(math.ceil(100*p)) .. " / 100"
        love.graphics.setFont(huge)
        love.graphics.print(progress, Vector.Size.x / 2 - huge:getWidth(progress) / 2, Vector.Size.y / 2 - 50)

        local text = preloadTexts[math.ceil(p*#preloadTexts)] .. "..."
        love.graphics.setFont(font)
        love.graphics.print(text, Vector.Size.x / 2 - font:getWidth(text) / 2, Vector.Size.y / 2 + 20)
    else
        love.graphics.setLineStyle("smooth")

        love.graphics.setColor(255, 255, 255)
        draw_rect(sky, 0, 0, Vector.Size.x, Vector.Size.y*0.4)

        for i = 1, #things do
            things[i]:draw()
        end
        drawDispatched()
    end
end

-- Event handling

function love.keypressed(key)
    if release then
        love.event.quit()
    else
        if key == "p" then
            paused = not paused
        elseif key == "t" then
            things = { Tree:new(Vector:new(Vector.Size.x / 2, Vector.Size.y * 0.6), 0.5) }
            -- things = { Grass:new(Vector:new(Vector.Size.x / 2, Vector.Size.y * 0.6), 0.5, Color.Red) }
        elseif key == "d" then
            debug = not debug
        elseif key == "0" then
            CameraOffset = 0
        elseif not debug or key == "escape" then
            love.event.quit()
        end
    end
end

function love.mousepressed()
    love.event.quit()
end
