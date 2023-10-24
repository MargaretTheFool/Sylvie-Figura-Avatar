-- Swing Physics script calls
local SwingingPhysics = require("SkirtPhys")
local swingOnBody = SwingingPhysics.swingOnBody

-- Parts

local parts = {
    models.Sylvie.Body.Skirt.N.N1,
    models.Sylvie.Body.Skirt.N.N2,
    models.Sylvie.Body.Skirt.NW.NW1,
    models.Sylvie.Body.Skirt.NW.NW3,
    models.Sylvie.Body.Skirt.NW.NW2,
    models.Sylvie.Body.Skirt.W.W3,
    models.Sylvie.Body.Skirt.W.W2,
    models.Sylvie.Body.Skirt.W.W1,
    models.Sylvie.Body.Skirt.SW.SW2,
    models.Sylvie.Body.Skirt.SW.SW1,
    models.Sylvie.Body.Skirt.S.S4,
    models.Sylvie.Body.Skirt.S.S3,
    models.Sylvie.Body.Skirt.S.S2,
    models.Sylvie.Body.Skirt.S.S1,
    models.Sylvie.Body.Skirt.S.S5,
    models.Sylvie.Body.Skirt.S.S6,
    models.Sylvie.Body.Skirt.S.S7,
    models.Sylvie.Body.Skirt.SE.SE1,
    models.Sylvie.Body.Skirt.SE.SE2,
    models.Sylvie.Body.Skirt.E.E1,
    models.Sylvie.Body.Skirt.E.E2,
    models.Sylvie.Body.Skirt.E.E3,
    models.Sylvie.Body.Skirt.NE.NE2,
    models.Sylvie.Body.Skirt.NE.NE3,
    models.Sylvie.Body.Skirt.NE.NE1,
    models.Sylvie.Body.Skirt.N.N3,
}
local partsWalkOffset = {
    
}

local prev = {

}

local LeftBias = {
    1,
    1,
    1,
    1,
    1,
    1,
    1,
    0.8,
    0.6,
    0.4,
    0.2,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.25,
    0.5,
    0.75,
}
local RightBias = {
    1,
    0.75,
    0.5,
    0.25,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0.2,
    0.4,
    0.6,
    0.8,
    1,
    1,
    1,
    1,
    1,
    1,
}

local cubes = {
    models.Sylvie.Body.Skirt.N.N1.N1,
    models.Sylvie.Body.Skirt.N.N2.N2,
    models.Sylvie.Body.Skirt.NW.NW1.NW1,
    models.Sylvie.Body.Skirt.NW.NW3.NW3,
    models.Sylvie.Body.Skirt.NW.NW2.NW2,
    models.Sylvie.Body.Skirt.W.W3.W3,
    models.Sylvie.Body.Skirt.W.W2.W2,
    models.Sylvie.Body.Skirt.W.W1.W1,
    models.Sylvie.Body.Skirt.SW.SW2.SW2,
    models.Sylvie.Body.Skirt.SW.SW1.SW1,
    models.Sylvie.Body.Skirt.S.S4.S4,
    models.Sylvie.Body.Skirt.S.S3.S3,
    models.Sylvie.Body.Skirt.S.S2.S2,
    models.Sylvie.Body.Skirt.S.S1.S1,
    models.Sylvie.Body.Skirt.S.S5.S5,
    models.Sylvie.Body.Skirt.S.S6.S6,
    models.Sylvie.Body.Skirt.S.S7.S7,
    models.Sylvie.Body.Skirt.SE.SE1.SE1,
    models.Sylvie.Body.Skirt.SE.SE2.SE2,
    models.Sylvie.Body.Skirt.E.E1.E1,
    models.Sylvie.Body.Skirt.E.E2.E2,
    models.Sylvie.Body.Skirt.E.E3.E3,
    models.Sylvie.Body.Skirt.NE.NE2.NE2,
    models.Sylvie.Body.Skirt.NE.NE3.NE3,
    models.Sylvie.Body.Skirt.NE.NE1.NE1,
    models.Sylvie.Body.Skirt.N.N3.N3,
    }

for i, part in ipairs(parts) do
    swingOnBody(part, (360/25) * (i - 1))
end

local rot = 0
local _rot = 0
local rotDelta
local yVel
local _yVel
local yVelDelta
local flairOut = 0
local _flairOut = 0
local legAngleLeft
local legAngleRight

function events.ENTITY_INIT()
    rot = player:getBodyYaw(1)
    _rot = rot
    rotDelta = math.abs(rot - _rot)
    yVel = player:getVelocity().y
    _yVel = yVel
    yVelDelta = yVel - _yVel
    legAngleLeft = vanilla_model.LEFT_LEG:getOriginRot().x 
    legAngleLeft = legAngleLeft + (math.abs(legAngleLeft * 0.5))
    legAngleRight = vanilla_model.RIGHT_LEG:getOriginRot().x
    legAngleRight = legAngleRight + (math.abs(legAngleRight * 0.5))
    for i in ipairs(parts) do
        partsWalkOffset[i] = cubes[i]:getOffsetRot().x + ((legAngleLeft * LeftBias[i]) + (legAngleRight * RightBias[i]))
    end
    for i in ipairs(parts) do
        prev[i] = partsWalkOffset[i]
    end
end

function events.tick()
    _rot = rot
    rot = player:getBodyYaw(1)
    rotDelta = math.abs(rot - _rot)
    _yVel = yVel
    yVel = player:getVelocity().y
    yVelDelta = yVel - _yVel
    _flairOut = flairOut
    flairOut = math.clamp(rotDelta, -5, 20) - math.clamp((yVel + (yVel * yVelDelta)) * 35, -35, 5)
    legAngleLeft = vanilla_model.LEFT_LEG:getOriginRot().x 
    if vanilla_model.LEFT_LEG:getRot() ~= nil then legAngleLeft = vanilla_model.LEFT_LEG:getRot().x end
    legAngleLeft = legAngleLeft + (math.abs(legAngleLeft * 0.5))
    legAngleRight = vanilla_model.RIGHT_LEG:getOriginRot().x
    if vanilla_model.RIGHT_LEG:getRot() ~= nil then legAngleRight = vanilla_model.RIGHT_LEG:getRot().x end
    legAngleRight = legAngleRight + (math.abs(legAngleRight * 0.5))
    for i in ipairs(parts) do
        prev[i] = partsWalkOffset[i]
    end
    for i in ipairs(parts) do
        partsWalkOffset[i] = ((legAngleLeft * LeftBias[i]) + (legAngleRight * RightBias[i]))
    end
    if player:getPose() == "CROUCHING" then
        for i in ipairs(parts) do
            if i >= 1 and i <= 4 or i >= 23 then
                parts[i]:setPos(0, 0.5, -0.5)
            end
            if i == 8 or i == 19 then
                parts[i]:setPos(0, 0, -0.05)
            end
            if i == 7 or i == 20 then
                parts[i]:setPos(0, 0 -0.125)
            end
            if i == 6 or i == 21 then
                parts[i]:setPos(0, 0, -0.125)
            end
            if i == 5 or i == 22 then
                parts[i]:setPos(0, 0, -0.25)
            end
        end
    else 
        for i in ipairs(parts) do
            parts[i]:setPos(0, 0, 0)
        end
    end
end

function events.render(delta)
    flairOut = (flairOut + flairOut + flairOut + flairOut + flairOut + _flairOut) / 6
    for i, cube in ipairs(cubes) do
        cube:setOffsetRot(vec(math.lerp(_flairOut, flairOut, delta), 0, 0))
    end
    for i, part in ipairs(parts) do
        part:setOffsetRot(math.lerp(prev[i], partsWalkOffset[i], delta), 0, 0)
    end
end