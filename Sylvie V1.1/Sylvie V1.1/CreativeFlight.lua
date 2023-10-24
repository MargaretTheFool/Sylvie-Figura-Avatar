-- Creative flight customisation script by DeadVoxels

-- Feel free to use and edit, but do give credit, do not use commercially (to make money), and do allow others use and make derivatives of your derivative work in the same way! 
-- (In short, this work is licensed under CC BY-NC-SA 4.0. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/)

-- Declare variables
local cFlightCheck = true
local horizVel = vec(0, 0)
local body = vanilla_model.BODY
local leftLeg = vanilla_model.LEFT_LEG
local rightLeg = vanilla_model.RIGHT_LEG
local leftArm = vanilla_model.LEFT_ARM
local rightArm = vanilla_model.RIGHT_ARM
local b = vec(0,0,0)
local ll = vec(0,0,0)
local rl = vec(0,0,0)
local la = vec(0,0,0)
local ra = vec(0,0,0)
local extraJointOffsets = { -- Rotational offsets for extra joint parts such as knees, ankles, feet (this was made for a digigrade leg avatar so those are indeed separate), elbows, etc.
    -- Left leg:
    vec(0, 10, 0), --LeftLeg
    vec(-49, -5.5, 6), --left_knee
    vec(68, 8.2, 4), --left_ankle
    vec(-32.5, 2.4, 1.45), --left_foot
    -- Right leg:
    vec(0, -5, 0), --RightLeg
    vec(68, -8.2, 4), --right_ankle
    vec(-32.5, -2.4, -1.45), --right_foot
    -- Left Arm:
    vec(-10.8, 9.1, -5), --LeftArm
    vec(14.9, 3, -1.8), --left_elbow
    -- Right Arm:
    vec(-10.8, -9.1, 5), --RightArm
    vec(14.9, -3, 1.8), --right_elbow
}

models.armband.root.RightElbow:moveTo(models.Sylvie.RightArm.right_arm.right_elbow)
models.armband.root.LeftElbow:moveTo(models.Sylvie.LeftArm.left_arm.left_elbow)

function HorizVel()
    if player:isLoaded() then
        local relativeVel = player:getVelocity()
        relativeVel = vectors.rotateAroundAxis(player:getRot().y, relativeVel.x_z, vec(0, 1, 0))
        horizVel.y = ((relativeVel.z * math.abs(relativeVel.z)))
        local _hVelY = horizVel.y
        horizVel.y = math.sqrt(math.abs(horizVel.y))
        horizVel.y = horizVel.y * (_hVelY / math.abs(_hVelY))
        if horizVel.y ~= horizVel.y then horizVel.y = 0 end 
        horizVel.x = ((relativeVel.x * math.abs(relativeVel.x)))
        local _hVelX = horizVel.x
        horizVel.x = math.sqrt(math.abs(horizVel.x))
        horizVel.x = horizVel.x * (_hVelX / math.abs(_hVelX))
        if horizVel.x ~= horizVel.x then horizVel.x = 0 end
        return horizVel
    end
end

-- Ping function to make sure this value is synced across clients - creative flight is otherwise not properly synced
function pings.cFlightTog(tog)
    cFlightCheck = tog
    return cFlightCheck
end

-- Check for every tick if the player is in creative flight. If they go from not flying to flying, or vice versa, it updates a boolean/toggle variable and initiates the above ping function to sync it
function events.tick()
    if host:isHost() and cFlightCheck ~= host:isFlying() then
        cFlightCheck = host:isFlying()
        pings.cFlightTog(cFlightCheck)
    end
end

-- Applies creative flight custom effects when the player is flying, and overrides vanilla rotations in so doing
local checkConfirm
local TickCheck = world.getTime()
function events.tick()
    HorizVel()
    if cFlightCheck then
        if cFlightCheck ~= checkConfirm then
            checkConfirm = cFlightCheck
            models.Sylvie.LeftLeg:moveTo(models.Sylvie.Body)
            models.Sylvie.RightLeg:moveTo(models.Sylvie.Body)
            models.Sylvie.LeftArm:moveTo(models.Sylvie.Body)
            models.Sylvie.RightArm:moveTo(models.Sylvie.Body)
        end
        ll = vec((-25 / (1 + horizVel:length() * 10)) - (horizVel.y * 30), 0, (7 / (1 + horizVel:length() * 15)) - (player:getVelocity().y * 10) + horizVel.x * 20)
        if ll.x ~= ll.x then
            ll = vec(-25, 0, 7 - (player:getVelocity().y * 10)) end
        rl = vec((10 / (1 + horizVel:length() * 10)) - (horizVel.y * 30), 0, (-7 / (1 + horizVel:length() * 15)) + (player:getVelocity().y * 10) + horizVel.x * 20)
        if rl.x ~= rl.x then
            rl = vec(10, 0, -7 + (player:getVelocity().y * 10)) end
        la = vec(-5 - (horizVel.y * 30), 0, -10 + (player:getVelocity().y * 20) + horizVel.x * 20)
        if la.x ~= la.x then
            la = vec(-5, 0, -10 + (player:getVelocity().y * 20)) end
        ra = vec(-5 - (horizVel.y * 30), 0, 10 - (player:getVelocity().y * 20) + horizVel.x * 20)
        if ra.x ~= ra.x then
            ra = vec(-5, 0, 10 - (player:getVelocity().y * 20)) end
        b = vec((-horizVel.y * 50), 0, horizVel.x * 20)
        if b.x ~= b.x then
            b = vec(0, 0, 0) end
        if body:getRot() == nil then
            body:setRot(b)
            leftArm:setRot(la)
            rightArm:setRot(ra)
            leftLeg:setRot(ll)
            rightLeg:setRot(rl)
        end
        if world.getTime() >= TickCheck + 3 then
            TickCheck = world.getTime()
            local cFlightMagicc1 = {}
            for i = 1, 2, 1 do
                cFlightMagicc1[i] = particles:newParticle("minecraft:end_rod")
                    :pos(models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle.left_foot:partToWorldMatrix():apply() + vectors.rotateAroundAxis(-player:getBodyYaw(), vec(0, 0, 0), vec(0, 1, 0)) + (vec(math.random() * math.random(-1, 1),(math.random() - 0.5) * math.random(-1, 1),math.random() * math.random(-1, 1)) / 2))
                    :lifetime(10)
                    :setColor(0.85, 0.55, 0.65, 0.5)
                    :velocity(vectors.rotateAroundAxis(-player:getBodyYaw(), vec(math.random() * math.random(-1, 1), (-0.75 + math.random() * math.random(-1, 1)) / 2, (math.random() * math.random(-1, 1)) / 2) / 16, vec(0, 1, 0)))
                    :gravity(0.05)
            end
            local cFlightMagicc2 = {}
            for i = 1, 2, 1 do
                cFlightMagicc2[i] = particles:newParticle("minecraft:end_rod")
                    :pos(models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle.right_foot:partToWorldMatrix():apply() + vectors.rotateAroundAxis(-player:getBodyYaw(), vec(0, 0, 0), vec(0, 1, 0)) + (vec(math.random() * math.random(-1, 1),(math.random() - 0.5) * math.random(-1, 1),math.random() * math.random(-1, 1)) / 2))
                    :lifetime(10)
                    :setColor(0.85, 0.55, 0.65, 0.5)
                    :velocity(vectors.rotateAroundAxis(-player:getBodyYaw(), vec(math.random() * math.random(-1, 1), (-0.75 + math.random() * math.random(-1, 1)) / 2, (math.random() * math.random(-1, 1)) / 2) / 16, vec(0, 1, 0)))
                    :gravity(0.05)
            end
            local cFlightMagicc3 = {}
            for i = 1, 2, 1 do
                cFlightMagicc3[i] = particles:newParticle("minecraft:end_rod")
                    :pos(models.Sylvie.RightArm.right_arm.right_elbow.right_pawbFinger1:partToWorldMatrix():apply() + vectors.rotateAroundAxis(-player:getBodyYaw(), vec(0, 0, 0), vec(0, 1, 0)) + (vec(math.random() * math.random(-1, 1),(math.random() - 0.5) * math.random(-1, 1),math.random() * math.random(-1, 1)) / 2))
                    :lifetime(10)
                    :setColor(0.85, 0.55, 0.65, 0.5)
                    :velocity(vectors.rotateAroundAxis(-player:getBodyYaw(), vec(math.random() * math.random(-1, 1), (-0.75 + math.random() * math.random(-1, 1)) / 2, (math.random() * math.random(-1, 1)) / 2) / 16, vec(0, 1, 0)))
                    :gravity(0.05)
            end
            local cFlightMagicc4 = {}
            for i = 1, 2, 1 do
                cFlightMagicc4[i] = particles:newParticle("minecraft:end_rod")
                    :pos(models.Sylvie.LeftArm.left_arm.left_elbow.left_pawbFinger1:partToWorldMatrix():apply() + vectors.rotateAroundAxis(-player:getBodyYaw(), vec(0, 0, 0), vec(0, 1, 0)) + (vec(math.random() * math.random(-1, 1),(math.random() - 0.5) * math.random(-1, 1),math.random() * math.random(-1, 1)) / 2))
                    :lifetime(10)
                    :setColor(0.85, 0.55, 0.65, 0.5)
                    :velocity(vectors.rotateAroundAxis(-player:getBodyYaw(), vec(math.random() * math.random(-1, 1), (-0.75 + math.random() * math.random(-1, 1)) / 2, (math.random() * math.random(-1, 1)) / 2) / 16, vec(0, 1, 0)))
                    :gravity(0.05)
            end
        end
        models.Sylvie.LeftLeg:rot(extraJointOffsets[1] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
        models.Sylvie.LeftLeg.left_thigh.left_knee:rot(extraJointOffsets[2] / (1 + horizVel:length() * 10) + (vec(-64.8593, -5.5048, 5.9588) * horizVel:length()))
        models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle:rot(extraJointOffsets[3] / (1 + horizVel:length() * 10) + (vec(70.0823 ,5.2595 ,0.0308) * horizVel:length()))
        models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle.left_foot:rot(extraJointOffsets[4] / (1 + horizVel:length() * 10) + (vec(-12.5, 0, 2) * horizVel:length()))
        models.Sylvie.RightLeg:rot(extraJointOffsets[5] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
        models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle:rot(extraJointOffsets[6] / (1 + horizVel:length() * 10) + (vec(70.0873, -5.2595, -0.0308) * horizVel:length()))
        models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle.right_foot:rot(extraJointOffsets[7] / (1 + horizVel:length() * 10) + (vec(-12.5, 0, -2) * horizVel:length()))
        models.Sylvie.LeftArm:rot(extraJointOffsets[8] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
        models.Sylvie.LeftArm.left_arm.left_elbow:rot(extraJointOffsets[9] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
        models.Sylvie.RightArm:rot(extraJointOffsets[10] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
        models.Sylvie.RightArm.right_arm.right_elbow:rot(extraJointOffsets[11] / (1 + horizVel:length() * 10) + (vec(0, 0, 0) * horizVel:length()))
    else if b ~= nil then 
        if checkConfirm ~= cFlightCheck then checkConfirm = cFlightCheck end
            models.Sylvie.LeftLeg:moveTo(models.Sylvie)
            models.Sylvie.RightLeg:moveTo(models.Sylvie)
            models.Sylvie.LeftArm:moveTo(models.Sylvie)
            models.Sylvie.RightArm:moveTo(models.Sylvie)
            models.Sylvie.LeftLeg:rot()
            models.Sylvie.LeftLeg.left_thigh.left_knee:rot(-64.8593, -5.5048, 5.9588)
            models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle:rot(70.0823 ,5.2595 ,0.0308)
            models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle.left_foot:rot(-12.5, 0, 2)
            models.Sylvie.RightLeg:rot()
            models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle:rot(70.0873, -5.2595, -0.0308)
            models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle.right_foot:rot(-12.5, 0, -2)
            models.Sylvie.LeftArm:rot()
            models.Sylvie.LeftArm.left_arm.left_elbow:rot()
            models.Sylvie.RightArm:rot()
            models.Sylvie.RightArm.right_arm.right_elbow:rot()
            ll = nil
            rl = nil
            la = nil
            ra = nil
            b  = nil
            body:setRot(b)
            leftArm:setRot(la)
            rightArm:setRot(ra)
            leftLeg:setRot(ll)
            rightLeg:setRot(rl)
        end
    end
end

function events.render(delta)
    if cFlightCheck then
        if b ~= nil then
            body:setRot(math.lerp(body:getRot(), b, delta))
            leftArm:setRot(math.lerp(leftArm:getRot(), la, delta))
            rightArm:setRot(math.lerp(rightArm:getRot(), ra, delta))
            leftLeg:setRot(math.lerp(leftLeg:getRot(), ll, delta))
            rightLeg:setRot(math.lerp(rightLeg:getRot(), rl, delta))
        end
    end
end