--▄▀█ █▀▄ █▀█ █ █▀ ▀█▀ █▀▀ █░░
--█▀█ █▄▀ █▀▄ █ ▄█ ░█░ ██▄ █▄▄

local TW = 1 --top wetness --wet effect
local BW = 1 --bottom wetness
local rot
local _rot
local rotD
local playerShake

function events.tick() 
    if player:isInRain() then --makes clothes wet if in rain
        TW = TW - 0.005
        BW = BW - 0.005
        if TW <= 0.75 then TW = 0.75 end
        if BW <= 0.6 then BW = 0.6 end
    end
    if player:isInWater() then BW = 0.4 end  --if player is standing in water, make bottom clothes wet
    if player:isUnderwater() then TW = 0.4 end --if player is submerged in water, make top clothes wet
	if not player:isUnderwater() and TW ~= 1 and not player:isInRain() then TW = TW + 0.005 end --if not submerged in water, dry top clothes
	if not player:isInWater() and BW ~= 1 and not player:isInRain() then BW = BW + 0.005 end --if not standing in water, dry bottom clothes
    if BW >= 1 then BW = 1 end
    if TW >= 1 then TW = 1 end
    if world.getTime() % 16 == 0 and (BW ~= 1 or TW ~= 1) then particles:newParticle("falling_dripstone_water",player:getPos().x + math.random() - 0.7, player:getPos().y +  math.random(), player:getPos().z + math.random() - 0.7, math.random(-1,1),  math.random(-1,1),  math.random(-1,1)) end
    playerShake = 0
    rot = player:getRot().y
    if _rot == nil then _rot = rot end
    local _rotD = rotD
    rotD = math.abs(rot - _rot)
    if _rotD ~= nil then rotD = rotD + (_rotD/1.5) end
    playerShake = math.clamp((playerShake + rotD)/2, 0, 200)
    local wawa = {}
    if world.getTime() % 16 == 0 and (BW ~= 1 or TW ~= 1) and playerShake >= 40 then for i = 1, 10, 1 do wawa[i] = particles:newParticle("minecraft:splash",player:getPos().x + math.random() - 0.7, player:getPos().y +  math.random(), player:getPos().z + math.random() - 0.7, math.random(-1,1),  math.random(-1,1),  math.random(-1,1)) end sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1, false) BW = BW + (BW / 3) TW = TW + (TW / 3) end
    _rot = rot

    --put clothes or fur on top half of body here
	--example: models.player.Base.Torso.Shirt:setColor(TW,TW,TW)
    models.Sylvie.Body.bodyTop:setColor(TW, TW, TW)
    models.Sylvie.Body.Sweater.SweaterTop:setColor(TW, TW, TW)
    models.Sylvie.Body.blahaj.q:setColor(TW, TW, TW)
    models.Sylvie.Body.blahaj.qw:setColor(TW, TW, TW)
    models.Sylvie.Body.blahaj.head2:setColor(TW, TW, TW)
    models.Sylvie.Body.blahaj.fin:setColor(TW, TW, TW)
    models.Sylvie.Body.blahaj.arms.larm:setColor(TW, TW, TW)
    models.Sylvie.Head.head:setColor(TW, TW, TW)
    models.Sylvie.Head.Hair:setColor(TW, TW, TW)
    models.Sylvie.Head.Bow:setColor(TW, TW, TW)
    models.Sylvie.Head.Ribbon1_1:setColor(TW, TW, TW)
    models.Sylvie.Head.Ribbon2_1:setColor(TW, TW, TW)
    models.Sylvie.Head.Muzzle:setColor(TW, TW, TW)
    models.Sylvie.Head.EmoteEffects:setColor(TW, TW, TW)
    models.Sylvie.Head.leftEar:setColor(TW, TW, TW)
    models.Sylvie.Head.rightEar:setColor(TW, TW, TW)
    models.Sylvie.LeftArm.left_arm.left_arm:setColor(TW, TW, TW)
    models.Sylvie.LeftArm.left_sleeve.left_sleeve:setColor(TW, TW, TW)
    models.Sylvie.LeftArm.left_sleeve.left_sleeve_cuff_thingie:setColor(TW, TW, TW)
    models.Sylvie.LeftArm.left_arm.left_elbow.left_sleeve_elbow.left_sleeve_elbow_top:setColor(TW, TW, TW)
    models.Sylvie.RightArm.right_arm.right_arm:setColor(TW, TW, TW)
    models.Sylvie.RightArm.right_sleeve.right_sleeve:setColor(TW, TW, TW)
    models.Sylvie.RightArm.right_sleeve.right_sleeve_cuff_thingie:setColor(TW, TW, TW)
    models.Sylvie.RightArm.right_arm.right_elbow.right_sleeve_elbow.right_sleeve_elbow_top:setColor(TW, TW, TW)

    --put clothes or fur on bottom half of body here
	--example: models.player.Base.Torso.Pants:setColor(BW,BW,BW)
    models.Sylvie.Body.bodyBottom:setColor(BW, BW, BW)
    models.Sylvie.Body.Sweater.SweaterBottom:setColor(BW, BW, BW)
    models.Sylvie.Body.tail_1:setColor(BW, BW, BW)
    models.Sylvie.Body.Skirt:setColor(BW, BW, BW)
    models.Sylvie.Body.ShortsHipBit:setColor(BW, BW, BW)
    models.Sylvie.Body.blahaj.arms.rarm:setColor(BW, BW, BW)
    models.Sylvie.Body.blahaj.tail:setColor(BW, BW, BW)
    models.Sylvie.LeftArm.left_arm.left_elbow:setColor(BW, BW, BW)
    models.Sylvie.LeftArm.left_arm.left_elbow.left_sleeve_elbow.left_sleeve_elbow_bottom:setColor(BW, BW, BW)
    models.Sylvie.LeftArm.left_arm.left_elbow.left_sleeve_elbow.left_sleeve_elbow_cuff_thingie:setColor(BW, BW, BW)
    models.Sylvie.RightArm.right_arm.right_elbow:setColor(BW, BW, BW)
    models.Sylvie.RightArm.right_arm.right_elbow.right_sleeve_elbow.right_sleeve_elbow_bottom:setColor(BW, BW, BW)
    models.Sylvie.RightArm.right_arm.right_elbow.right_sleeve_elbow.right_sleeve_elbow_cuff_thingie:setColor(BW, BW, BW)
    models.armband:setColor(BW, BW, BW)
    models.Sylvie.LeftLeg:setColor(BW, BW, BW)
    models.Sylvie.RightLeg:setColor(BW, BW, BW)

end
