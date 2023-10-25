-- NOT BY ME - Script written by Discord user @auriafoxgirl. All credit goes to her, since I just tried to implement this to understand how to implement animations (and to make my first avatar into a mediocrely decent one lol) /DeadVoxels
-- config --
local configParams = {
    modelPart = models.Sylvie.Body.tail_1, -- model part of tail

    rotVelocityStrength = 0.2,
    rotVelocityLimit = 12,

    verticalVelocityStrength = 10,
    verticalVelocityMin = -2,
    verticalVelocityMax = 5,

    lessCurveWhenUp = true,

    wagSpeed = .1,
    wagStrength = 2,
    enableWag = {}, -- if any variable in this table is true tail will wag (default value = {})
    wagToggle = true, -- Pathetic attempt at making the wag bind a toggle lol (NEVERMIND IT WORKED, GUESS IT WASN'T SO BAD LOL)

    walkWagSpeed = 0.5,
    walkWagStrength = 0.75,

    -- table containing functions with argument rot that is table of vectors that controls tail rotation, returning true will stop physics, can be used for sleeping animation
    rotOverride = {}
}

local tailPage

local WagSp

local WagSt

local wagToggle

local toggleBtn

local wagOffTex
local wagOnTex
local wagSpdHiTex
local wagStrLoTex
local wagStrMedTex
local wagStrHiTex
local SaveIco

if host:isHost() then
    wagOffTex = textures:read("SylvieWagOff", config:load("SylvieWagOffTex") --[[@as string]])
    wagOnTex = textures:read("SylvieWagOn", config:load("SylvieWagOnTex") --[[@as string]])
    wagSpdHiTex = textures:read("SylvieWagSpdHi", config:load("SylvieWagSpdHiTex") --[[@as string]])
    wagStrLoTex = textures:read("SylvieWagStrLo", config:load("SylvieWagStrLoTex") --[[@as string]])
    wagStrMedTex = textures:read("SylvieWagStrMed", config:load("SylvieWagStrMedTex") --[[@as string]])
    wagStrHiTex = textures:read("SylvieWagStrHi", config:load("SylvieWagStrHiTex") --[[@as string]])
    SaveIco = textures:read("SaveIco", config:load("SaveIco") --[[@as string]])
end

function pings.WagSpReset()
    configParams.wagSpeed = 0.1
    if host:isHost() then
        WagSp:setTitle("Wag speed (Scroll to change, 0.1 - 1, default 0.1) | " .. configParams.wagSpeed .. " |")
        WagSp:setColor((configParams.wagSpeed-0.1)/0.9,(configParams.wagSpeed-0.1)/0.9,(configParams.wagSpeed-0.1)/0.9)
        WagSp:hoverColor(configParams.wagSpeed/0.25,configParams.wagSpeed/0.9,configParams.wagSpeed/0.35)
    end
end


function pings.WagSpScroll(dir)
    configParams.wagSpeed = math.clamp(configParams.wagSpeed + dir * 0.05, 0.1, 1)
    if host:isHost() then
        WagSp:setColor((configParams.wagSpeed-0.1)/0.9,(configParams.wagSpeed-0.1)/0.9,(configParams.wagSpeed-0.1)/0.9)
        WagSp:hoverColor(configParams.wagSpeed/0.25,configParams.wagSpeed/0.9,configParams.wagSpeed/0.35)
        WagSp:setTitle("Wag speed (Scroll to change, 0.1 - 1, default 0.1) | " .. configParams.wagSpeed .. " |")
    end
end

function pings.WagStReset()
    configParams.wagStrength = 2
    if host:isHost() then
        WagSt:setColor((configParams.wagStrength-0.5)/7,(configParams.wagStrength-0.5)/7,(configParams.wagStrength-0.5)/7)
        WagSt:hoverColor(configParams.wagStrength/2.25,configParams.wagStrength/6.5,configParams.wagStrength/2.75)
        WagSt:setTitle("Wag strength (Scroll to change, 0.5 - 7.5, default 2) | " .. configParams.wagStrength .. " |")
    end
end

function pings.WagStScroll(dir)
    configParams.wagStrength = math.clamp(configParams.wagStrength + dir * 0.5, 0.5, 7.5)
    if host:isHost() then
        WagSt:setColor((configParams.wagStrength-0.5)/7,(configParams.wagStrength-0.5)/7,(configParams.wagStrength-0.5)/7)
        WagSt:hoverColor(configParams.wagStrength/1.95,configParams.wagStrength/7,configParams.wagStrength/2.8)
        WagSt:setTitle("Wag strength (Scroll to change, 0.5 - 7.5, default 2) | " .. configParams.wagStrength .. " |")
    end
end
if host:isHost() then
    tailPage=action_wheel:newPage()
        toggleBtn=tailPage:newAction()
            :title("Wag Toggle (off)")
            :setTexture(wagOffTex,0,0,128,128,0.25)
            :toggleTitle("Wag Toggle (on)")
            :toggleColor(0.85, 0.25, 0.75)
            :hoverColor(0.75,0.7,0.725)
            :setToggleTexture(textures['SylvieWagOn'],0,0,128,128,0.25)
            :onToggle(function() wagToggle = not wagToggle pings.tailWag(wagToggle) toggleBtn:hoverColor(0.8,0.4,0.75) end)
            :onUntoggle(function() wagToggle = not wagToggle pings.tailWag(wagToggle) toggleBtn:hoverColor(0.75,0.7,0.725) end)
        WagSp=tailPage:newAction()
            :title("Wag speed (Scroll to change, 0.1 - 1, default 0.1) | " .. configParams.wagSpeed .. " |")
            :hoverColor(configParams.wagSpeed/0.25,configParams.wagSpeed/0.9,configParams.wagSpeed/0.35)
            :setOnScroll(function (dir)
                pings.WagSpScroll(dir)
            end)
            WagSp:onLeftClick(pings.WagSpReset)
        WagSt=tailPage:newAction()
            :title("Wag strength (Scroll to change, 0.5 - 7.5, default 2) | " .. configParams.wagStrength .. " |")
            :setTexture(wagStrMedTex)
            :hoverColor(configParams.wagStrength/2.25,configParams.wagStrength/6.5,configParams.wagStrength/2.75)
            :setOnScroll(function (dir)
                pings.WagStScroll(dir)
            end)
            :onLeftClick(pings.WagStReset)
        WagConfig=tailPage:newAction()
            :title("Save settings (Saved settings are used when the avatar is loaded in. Right click to clear save)")
            :texture(SaveIco, 0, 0, nil, nil, 1.5)
            :hoverColor(0.75,0.7,0.725)
            :onLeftClick(function()
                config:save("TailSave", true)
                config:save("wagToggle", wagToggle)
                config:save("WagSpeed", configParams.wagSpeed)
                config:save("WagStrength", configParams.wagStrength)
            end)
            :onRightClick(function ()
                config:save("TailSave", nil)
                config:save("wagToggle", nil)
                config:save("WagSpeed", nil)
                config:save("WagStrength", nil)
            end)
        end

function pings.tailWag(x)
    configParams.enableWag.keybind = x
end

function events.ENTITY_INIT()
    if host:isHost() then
        if config:load("TailSave") ~= nil then
            wagToggle = config:load("wagToggle")
            configParams.wagSpeed = config:load("WagSpeed")
            configParams.wagStrength = config:load("WagStrength")
            toggleBtn:setToggled(wagToggle)
            pings.tailWag(wagToggle)
            pings.WagSpScroll(0)
            pings.WagStScroll(0)
        end
    end
end

-- code --
if not configParams.modelPart then
    error("model part not found")
end

local wagTime = 0
local walkWagTime = 0
local parts = {}
local vel = vec(0, 0, 0) -- velocity or something
local rot = {}           -- list of tail rotations
local oldRot = {}        -- mom of list of tail rotations

local targetRot = vec(0, 0, 0)
local mulRot = {}
local addRot = {}
-- find parts
do
    local currentPart = configParams.modelPart
    local n, i = currentPart:getName():match("^(.-)(-?%d*)$")
    i = tonumber(i) or 1
    while currentPart do
        table.insert(parts, currentPart)
        local r = currentPart:getRot()
        table.insert(rot, r)
        i = i + 1
        currentPart = currentPart[n .. i]
    end
    local startRotLimit = #parts * 0.4
    local startRotSum = vec(0, 0, 0)
    local averageAbsRot = vec(0, 0, 0)
    for i = 1, #parts do
        startRotSum = startRotSum + math.max(1 - (i - 1) / startRotLimit, 0) * rot[i]
        averageAbsRot = averageAbsRot + rot[i]:copy():applyFunc(math.abs)
    end
    targetRot = averageAbsRot / #parts * startRotSum:applyFunc(function(a) return a < 0 and -1 or 1 end)
    for i = 1, #parts do
        local r = rot[i]
        local add = vec(0, 0, 0)
        local mul = vec(1, 1, 1)
        for axis = 1, 3 do
            local difference = r[axis] - targetRot[axis]
            local flippedDifference = r[axis] + targetRot[axis]
            if math.abs(difference) <= math.abs(flippedDifference) then
                add[axis] = difference
            else
                add[axis] = flippedDifference
                mul[axis] = -1
            end
        end
        mulRot[i] = mul
        addRot[i] = add
        rot[i] = targetRot
        oldRot[i] = targetRot
    end
end

function events.tick()

    -- update rotation
    for i = #rot, 1, -1 do
        oldRot[i] = rot[i]
        if i ~= 1 then
            rot[i] = rot[i - 1]:copy()
        else
            rot[i] = rot[i]:copy()
        end
    end
    -- override
    for _, v in ipairs(configParams.rotOverride) do
        if v(rot) then
            return
        end
    end
    -- velocity
    local bodyRot = player:getBodyYaw(1)
    local playerVel = vectors.rotateAroundAxis(bodyRot, player:getVelocity(), vec(0, 1, 0))
    local bodyVel = (bodyRot - player:getBodyYaw(0) + 180) % 360 - 180
    bodyVel = math.clamp(bodyVel * configParams.rotVelocityStrength, -configParams.rotVelocityLimit, configParams.rotVelocityLimit)
    -- check if in liquid
    local pos = parts[1]:partToWorldMatrix():apply()
    local inFluid = #world.getBlockState(pos + vec(0, 0.5, 0)):getFluidTags() ~= 0
    -- body pitch
    local bodyPitch = 0
    local playerPose = player:getPose()
    if playerPose == "SWIMMING" then
        if inFluid then
            bodyPitch = -90 - player:getRot().x
        else
            bodyPitch = -90
        end
    elseif playerPose == "FALL_FLYING" or playerPose == "SPIN_ATTACK" then
        bodyPitch = -90 - player:getRot().x
    end
    playerVel = vectors.rotateAroundAxis(bodyPitch, playerVel, vec(1, 0, 0))
    -- update velocity
    local currentTargetRot = targetRot:copy()
    if inFluid then
        local t = math.clamp(math.cos(math.rad(bodyPitch)), 0, 1)
        currentTargetRot.x = math.lerp(currentTargetRot.x, -0.8 * math.abs(currentTargetRot.x), t)
    elseif #world.getBlockState(pos):getFluidTags() ~= 0 then
        currentTargetRot.x = 0
    end
    vel = inFluid and vel * 0.4 or vel * 0.7
    vel = vel + (currentTargetRot - rot[1]) * 0.1
    -- update rotation
    rot[1] = rot[1] + vel
    rot[1].x = rot[1].x *
    (1 - math.clamp(math.abs(bodyVel / configParams.rotVelocityLimit) * 0.25 + playerVel.z * 1.5, -0.05, 1))
    rot[1].x = rot[1].x +
    math.clamp(playerVel.y * configParams.verticalVelocityStrength, -configParams.verticalVelocityMax, -configParams.verticalVelocityMin)
    rot[1].y = rot[1].y + bodyVel * math.clamp(1 - playerVel.xz:length() * 8, 0.2, 1) +
    math.clamp(playerVel.x * 20, -2, 2)
    -- wag
    rot[1].y = rot[1].y +
    math.cos(walkWagTime * configParams.walkWagSpeed) * configParams.walkWagStrength * math.clamp(playerVel.z * 4, 0, 1)
    for _, v in pairs(configParams.enableWag) do
        if v then
            rot[1].y = rot[1].y + math.cos(wagTime * configParams.wagSpeed) * configParams.wagStrength
            break
        end
    end
    -- time
    wagTime = wagTime + 1
    walkWagTime = walkWagTime + math.clamp(playerVel.z * 4, 0, 1)
    if host:isHost() then
        if configParams.wagStrength > 2.5 then
            WagSt:setTexture(wagStrHiTex,0,0,128,128,0.25)
        else 
            if configParams.wagStrength < 1.5 then
                WagSt:setTexture(wagStrLoTex,0,0,128,128,0.25)
            else
                WagSt:setTexture(wagStrMedTex,0,0,128,128,0.25)
            end
        end
        if configParams.wagSpeed > 0.3 then
            WagSp:setTexture(wagSpdHiTex,0,0,128,128,0.25)
        else 
            if configParams.wagSpeed < 0.2 then
                WagSp:setTexture(wagOffTex,0,0,128,128,0.25)
            else
                WagSp:setTexture(wagOnTex,0,0,128,128,0.25)
            end
        end
    end
    if player:getPose() == "CROUCHING" then
        models.Sylvie.Body.tail_1:setOffsetRot(35, 0, 0)
        models.Sylvie.Body.tail_1.tail_2:setOffsetRot(-35, 0, 0)
    else 
        models.Sylvie.Body.tail_1:setOffsetRot(0, 0, 0)
        models.Sylvie.Body.tail_1.tail_2:setOffsetRot(0, 0, 0)
    end
end

function events.render(delta)
    if configParams.lessCurveWhenUp then
        for i, v in ipairs(parts) do
            local r = math.lerp(oldRot[i], rot[i], delta)
            local m = mulRot[i]:copy()
            if r.x < 0 then
                m.x = 1
                v:setRot(math.lerp(oldRot[i], rot[i], delta) * m + addRot[i])
            else
                v:setRot(r * m + addRot[i])
            end
        end
    else
        for i, v in ipairs(parts) do
            v:setRot(math.lerp(oldRot[i], rot[i], delta) * mulRot[i] + addRot[i])
        end
    end
end

 -- code by Auria <3

-- This variable stores the Page to go back to when done with this Page
local prevPage
-- This Action just sets the stored page as active
if host:isHost() then
    tailPage:newAction()
      :title('Back')
      :item("minecraft:barrier")
      :onLeftClick(function() 
        action_wheel:setPage("HomePage") 
      end)

    return action_wheel:newAction()
      :title("Tail control")
      :setTexture(wagOffTex,0,0,128,128,0.25)
      :onLeftClick(function()
        --store the current active page so that we can set it back as active later
        prevPage=action_wheel:getCurrentPage()
        --set this file's page as active
        action_wheel:setPage(tailPage)
      end)
end