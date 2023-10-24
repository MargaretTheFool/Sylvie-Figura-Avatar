-- NOT (fully) BY ME - Script written by Discord user @auriafoxgirl. All credit goes to her, since I just tried to implement this to understand how to implement animations (and to make my first avatar into a mediocrely decent one lol) /DeadVoxels

-- configParams --

local configParams = {
    leftEar = models.Sylvie.Head.leftEar, -- model part of left ear
    rightEar = models.Sylvie.Head.rightEar, -- model part of right ear

    velocityStrength = 1,

    extraAngle = 15, -- rotates ears by this angle when crouching
    useExtraAngle = {}, -- if any of variables in this table is true extraAngle will be used even when not crouching

    addAngle = {}, -- adds angle to ear rotation
}

local earsPageIco
local noFlopTex
local floppyTex
local floppierTex

local floppiness

if host:isHost() then
    earsPageIco = textures:read("SylvieEarsPageIco", config:load("SylvieEarsPageIcoTex") --[[@as string]])
    noFlopTex = textures:read("SylvieEarsNoFlop", config:load("SylvieEarsNoFlopTex") --[[@as string]])
    floppyTex = textures:read("SylvieEarsFloppy", config:load("SylvieEarsFloppyTex") --[[@as string]])
    floppierTex = textures:read("SylvieEarsFloppier", config:load("SylvieEarsFloppierTex") --[[@as string]])
    if config:load("EarFlop") ~= nil then
        configParams.velocityStrength = config:load("EarFlop")
    end
end

function flopReset()
    pings.flopReset()
    floppiness:setTitle("Ear floppiness (Scroll to change, 0-2, 1 default) | " .. configParams.velocityStrength .. " |")
    config:save("EarFlop", configParams.velocityStrength)
    floppiness:setColor(configParams.velocityStrength/2,configParams.velocityStrength/4,configParams.velocityStrength/2.2)
    floppiness:hoverColor(configParams.velocityStrength/2,configParams.velocityStrength/3,configParams.velocityStrength/2.1)
end

function pings.flopReset()
    configParams.velocityStrength = 1
end

function flopScroll(dir)
    pings.flopScroll(dir)
    config:save("EarFlop", configParams.velocityStrength)
    floppiness:setTitle("Ear floppiness (Scroll to change, 0-2, 1 default) | " .. configParams.velocityStrength .. " |")
    floppiness:setColor(configParams.velocityStrength/2,configParams.velocityStrength/4,configParams.velocityStrength/2.2)
    floppiness:hoverColor(configParams.velocityStrength/2,configParams.velocityStrength/3,configParams.velocityStrength/2.1)
end

function pings.flopScroll(dir)
    configParams.velocityStrength = math.clamp(configParams.velocityStrength + dir / 20, 0, 2)
end

 -- Action wheel stuff
 local earsPage
    earsPage=action_wheel:newPage()
        floppiness=earsPage:newAction()
            :title("Ear floppiness (Scroll to change, 0-2, 1 default) | " .. configParams.velocityStrength .. " |")
            :hoverColor(configParams.velocityStrength/2,configParams.velocityStrength/3,configParams.velocityStrength/2.1)
            :setColor(configParams.velocityStrength/2,configParams.velocityStrength/4,configParams.velocityStrength/2.2)
            :setOnScroll(function (dir)
                flopScroll(dir)
            end)
            :onLeftClick(flopReset)
            if host:isHost() then
            floppiness:setTexture(floppyTex,0,0,64,64,0.5)
            end

    local prevPage
    -- This Action just sets the stored page as active
    earsPage:newAction()
    :title('Back')
    :item("minecraft:barrier")
    :onLeftClick(function() 
     action_wheel:setPage("HomePage") 
    end)

-- code --

if not configParams.leftEar then
    error("no model part for left ear found")
end
if not configParams.rightEar then
    error("no model part for right ear found")
end

local defaultLeftEarRot = configParams.leftEar:getRot()
local defaultRightEarRot = configParams.rightEar:getRot()
local rot = vec(0, 0, 0, 0)
local oldRot = rot
local vel = vec(0, 0, 0, 0)
local oldPlayerRot = nil

function events.tick()
    if host:isHost() then
        if configParams.velocityStrength > 1.2 then
            floppiness:setTexture(floppierTex,0,0,64,64,0.5)
            else 
            if configParams.velocityStrength < 0.8 then
                floppiness:setTexture(noFlopTex,0,0,64,64,0.5)
                else
                floppiness:setTexture(floppyTex,0,0,64,64,0.5)
            end
        end
    end
    -- set oldRot
    oldRot = rot
    -- set target rotation
    local targetRot = 0
    if player:getPose() == "CROUCHING" then
        targetRot = 15
    else
        for _, v in pairs(configParams.useExtraAngle) do
            if v then
                targetRot = 15
                break
            end
        end
    end
    for _, v in pairs(configParams.addAngle) do
        targetRot = targetRot + v
    end
    -- player velocity
    local playerRot = player:getRot()
    if not oldPlayerRot then
        oldPlayerRot = playerRot
    end
    local playerRotVel = (playerRot - oldPlayerRot) * 0.75 * configParams.velocityStrength
    oldPlayerRot = playerRot
    local playerVel = player:getVelocity()
    playerVel = vectors.rotateAroundAxis(playerRot.y, playerVel, vec(0, 1, 0))
    playerVel = vectors.rotateAroundAxis(-playerRot.x, playerVel, vec(1, 0, 0))
    playerVel = playerVel * configParams.velocityStrength * 40
    -- update velocity and rotation
    vel = vel * 0.6 + (vec(0, 0, 0, targetRot) - rot) * 0.2
    rot = rot + vel
    rot.x = rot.x + math.clamp(playerVel.z + playerRotVel.x, -14, 14)
    rot.z = rot.z + math.clamp(-playerVel.x, -6, 6)
end

function events.render(delta)
    local currentRot = math.lerp(oldRot, rot, delta)
    configParams.leftEar:setRot(defaultLeftEarRot + currentRot.xyz + currentRot.__w)
    configParams.rightEar:setRot(defaultRightEarRot + currentRot.x_z - currentRot._yw)
end

 -- by Auria <3


if host:isHost() then
    return action_wheel:newAction()
      :title("Ear control")
      :setTexture(earsPageIco,0,0,64,64,0.5)
      :onLeftClick(function()
        --store the current active page so that we can set it back as active later
        prevPage=action_wheel:getCurrentPage()
        --set this file's page as active
        action_wheel:setPage(earsPage)
      end)
end