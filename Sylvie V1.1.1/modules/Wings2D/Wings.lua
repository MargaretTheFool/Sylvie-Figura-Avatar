-- 2D Wings by Manuel_2867
models.wings2D:setPrimaryRenderType("TRANSLUCENT")
models.wings2D:setSecondaryRenderType("eyes")
-- Settings
local elytra = true -- set to true if you want the wings to only show up when wearing an elytra
local flyingOnly = true -- set to true if you want the wings to show only when flying (You can set up a "deactivated mode" using this if you want to as well)
local cFlightAllow = true -- set to false if you don't want elytra wings to show when in creative flight
local fold_wings = true -- set to false if you want the wings to always be opened
local open_when_crouching = true -- open wings when crouching (Changed to holding sneak and sprint)
local strength = 12 -- how far the wings flap when flying
local glide_strength = 2 -- how far the wings flap when gliding
local speed = 0.25 -- how fast the wings flap
local rotation_offset = 30 -- default rotation offset of the wings
local curve = 0.3 -- how much the wings should curve when flapping
local idle_curve = -3 -- curves wings when not flying
local fly_rot = 0 -- when flying wings rotation
local fly_pos = 0 -- when flying wings y pos
local ground_rot = 15 -- on ground wings rotation
local ground_pos = 2 -- on ground wings y pos
local transition_speed = 0.15 -- transition speed
local invertRotation = true -- flap the wings the other direction
-- Settings end

local playervelocity = vec(0,0,0)
local cape_rotation = vec(0,0,0)

function pings.elytraTog()
    elytra = not elytra
    if host:isHost() then
        config:save("elytra", elytra)
    end
end

function pings.flyingOnlyTog()
    flyingOnly = not flyingOnly
    if host:isHost() then
        config:save("flyOnly", flyingOnly)
    end
end

function pings.foldTog()
    fold_wings = not fold_wings
    if host:isHost() then
        config:save("wingFold", fold_wings)
    end
end

function pings.crouchOpenTog()
    open_when_crouching = not open_when_crouching
    if host:isHost() then
        config:save("runUpFlaps", open_when_crouching)
    end
end

function pings.cflightToggler()
    cFlightAllow = not cFlightAllow
    if host:isHost() then
        config:save("cFlightAllowWings", cFlightAllow)
    end
end

function pings.WingsSync(el, fl, fw, op, cf)
    elytra = el
    flyingOnly = fl
    fold_wings = fw
    open_when_crouching = op
    cFlightAllow = cf
end

if host:isHost()  then
    elytra = config:load("elytra")
    if config:load("elytra") == nil then elytra = true end
    flyingOnly = config:load("flyOnly")
    if config:load("flyOnly") == nil then flyingOnly = false end
    fold_wings = config:load("wingFold")
    if config:load("wingFold") == nil then fold_wings = true end
    open_when_crouching = config:load("runUpFlaps") 
    if config:load("runUpFlaps") == nil then open_when_crouching = true end
    cFlightAllow = config:load("cFlightAllowWings")
    if config:load("cFlightAllowWings") == nil then cFlightAllow = true end
    pings.WingsSync(elytra, flyingOnly, fold_wings, open_when_crouching, cFlightAllow)
end

-- Action wheel stuff
WingWheel = action_wheel:newPage("WingPage")
local elytraOnly = WingWheel:newAction()
    :title("Only show when elytra is equipped?")
    :onLeftClick(pings.elytraTog)

local flyOnly = WingWheel:newAction()
    :title("Only show when flying?")
    :onLeftClick(pings.flyingOnlyTog)

local foldToggl = WingWheel:newAction()
    :title("Fold on ground?")
    :onLeftClick(pings.foldTog)

local crouchOpen = WingWheel:newAction()
    :title("Open when holding crouch + sprint?")
    :onLeftClick(pings.crouchOpenTog)

local cFlight = WingWheel:newAction()
    :title("Open when in creative flight?")
    :onLeftClick(pings.cflightToggler)

    WingWheel:newAction()
        :title('Back')
        :item("minecraft:barrier")
        :onLeftClick(function() 
            action_wheel:setPage("HomePage") 
        end)

-- Calculate cape rotation
do
    local lerp = math.lerp
    local math_floor = math.floor
    local math_acos = math.acos
    local math_max = math.max
    local math_sin = math.sin
    local world_getTime = world.getTime
    local player_getPos = nil
    local player_getRot = nil
    local player_getLookDir = nil
    function events.ENTITY_INIT()
        player_getPos = player.getPos
        player_getRot = player.getRot
        player_getLookDir = player.getLookDir
    end
    do
        local velocityPos = vec(0,0,0)
        local lastVelocityPos = vec(0,0,0)
        function events.ENTITY_INIT()
            velocityPos = player_getPos(player)
            lastVelocityPos = player_getPos(player)
        end
        function events.TICK()
            velocityPos = player_getPos(player)
            playervelocity = (velocityPos-lastVelocityPos)/1.8315
            lastVelocityPos = player_getPos(player)
        end
    end

    local vel = vec(0,0,0)

    local function move_direction()
        local veln = vel:normalized()
        local dir = player_getLookDir(player)
        dir = vec(dir[1],0,dir[3]):normalized()
        return veln:length() == 0 and 0 or math_floor(1+math_acos(veln:dot(dir))*1.4)
    end
    
    local headDir = 0
    local lastHeadDir = 0
    local speed = 0
    local lastSpeed = 0
    local capeRot = vec(0,0,0)
    local lastCapeRot = vec(0,0,0)
    
    local function capePhysics()
        vel = vec(playervelocity[1],0,playervelocity[3])
        
        lastHeadDir = headDir
        lastSpeed = speed
        lastCapeRot = capeRot

        headDir = -player_getRot(player).y
        local diff = lastHeadDir-headDir
        diff = diff*(-speed/50)

        if move_direction() > 3 then
            speed = math_sin(world_getTime()*1)*4-20 -- walk backwards animation
        else
            speed = math_max(lerp(lastSpeed,-vel:length()*350,0.3), -70) -- lerp for slowing down the cape
        end

        capeRot = vec(speed, 0, diff)
    end
    function events.TICK()
        capePhysics()
    end
    function events.RENDER(delta)
        cape_rotation = lerp(lastCapeRot, capeRot, delta)
    end
end

local FlightChecker1
function pings.cFlightSync(tog)
    FlightChecker1 = tog
end

local x
local _x
local TickCheck = world.getTime()
local cFlight = false
function events.tick()
    if host:isHost() then 
        FlightChecker1 = host:isFlying() 
        FlightChecker1 = FlightChecker1 and cFlightAllow
        pings.cFlightSync(FlightChecker1) 
    end
    local elytraWorn = player:getItem(5).id == "minecraft:elytra"
    local flying = (flyingOnly == false) or player:getPose() == "FALL_FLYING" or FlightChecker1 == true
    local WingsOnSound = sounds["minecraft:entity.allay.ambient_with_item"]
    :volume(0.15)
    :pitch(1.1)
    :subtitle("Sylvie's wings appear")
    local WingsOffSound = sounds["minecraft:entity.allay.item_taken"]
    :volume(0.1)
    :pitch(0.85)
    :subtitle("Sylvie's wings disappear")
    _x = x
    x = (elytra == false) or (elytraWorn and flying) and 0.02 or -0.01
    if _x == nil then _x = x end
    if _x ~= x then
        if x == 0.02 then
            local WingsPoof = {}
            for i = 0, 25, 1 do
                WingsPoof[i] = particles:newParticle("minecraft:end_rod", player:getPos() + vec(0, 1, 0))
                    :setColor(1, 0.45, 0.65)
                    :lifetime(35)
                    :setVelocity(vec(math.random() * math.random(-1, 1),math.random() * math.random(-1, 1),math.random() * math.random(-1, 1)) / 2)
            end
            WingsOnSound:play()
        else
            WingsOffSound:play()
        end
    end
    if elytraWorn and not flying then
        if world.getTime() >= TickCheck + 10 then
            TickCheck = world.getTime()
            local WingsInactive = {}
            for i = 0, 1, 1 do
                WingsInactive[i] = particles:newParticle("minecraft:end_rod")
                    :pos(player:getPos() + vectors.rotateAroundAxis(-player:getBodyYaw(), vec(0, 1.25, -0.2), vec(0, 1, 0)))
                    :lifetime(15)
                    :setColor(0.85, 0.45, 0.85, 0.5)
                    :velocity(vectors.rotateAroundAxis(-player:getBodyYaw(), vec(math.random() * math.random(-1, 1), (0.2 + math.random() * math.random(-1, 1)) / 2, (-0.2 + math.random() * math.random(-1, 1)) / 2) / 16, vec(0, 1, 0)))
                    :gravity(0.05)
            end
        end
    end
    WingsOnSound:setPos(player:getPos())
    WingsOffSound:setPos(player:getPos())
end
local opacity = 0
function events.render()
    if elytra then
        opacity = math.clamp(opacity + x, 0, 0.75)
        models.wings2D.Body:setOpacity(opacity)
        if models.wings2D.Body:getVisible() == true and opacity == 0 then 
            models.wings2D.Body:setVisible(false)
        elseif models.wings2D.Body:getVisible() == false and opacity > 0 then
            models.wings2D.Body:setVisible(true)
        end
    end
end

local zrot = 0
local _zrot = 0
local zrot_target = ground_rot
local ypos = 0
local _ypos = 0
local ypos_target = ground_pos
local str = 0
local _str = 0
local str_target = strength
local invertMultiplier = invertRotation == true and -1 or 1
local invertStrength = invertRotation == true and 3 or 1
local invertTimeOffset = invertRotation == true and 20 or 0

local sprint = keybinds:fromVanilla("key.sprint")
local crouch = keybinds:fromVanilla("key.sneak")

function events.TICK()
    _zrot = zrot
    zrot = math.lerp(zrot,zrot_target,transition_speed)
    _ypos = ypos
    ypos = math.lerp(ypos,ypos_target,transition_speed)
    _str = str
    str = math.lerp(str,str_target,transition_speed)
    if (player:getPose() == "FALL_FLYING") or (not fold_wings) or FlightChecker1 or ((sprint:isPressed() and crouch:isPressed()) and open_when_crouching) then
        zrot_target = fly_rot
        ypos_target = fly_pos
    else
        zrot_target = ground_rot
        ypos_target = ground_pos
    end
    if playervelocity.y < 0 then
        str_target = glide_strength
    else
        str_target = strength
    end
end

function events.RENDER(delta)
    local vel = player:getVelocity():length() * 15
    local zrot_ = math.lerp(_zrot,zrot,delta)
    zrot_ = math.clamp(zrot_ + vel, 0, 60)
    local str_ = math.lerp(_str,str,delta)
    local crouch_offset = player:getPose() == "CROUCHING" and 2 or 0

    models.wings2D.Body.LW:setPos(1,math.lerp(_ypos,ypos,delta),crouch_offset)
    models.wings2D.Body.RW:setPos(-1,math.lerp(_ypos,ypos,delta),crouch_offset)

    local time = world.getTime()+delta
    if player:getPose() == "FALL_FLYING" or FlightChecker1 or ((sprint:isPressed() and crouch:isPressed()) and open_when_crouching) then
        local rl = -(math.sin(time*speed)*str_)*curve
        local rr = (math.sin(time*speed)*str_)*curve

        models.wings2D.Body.LW:setRot(0, rotation_offset-math.sin((invertTimeOffset+time)*speed)*str_*invertMultiplier*(invertStrength/2), zrot_)
        models.wings2D.Body.LW.two:setRot(0, rl*invertStrength, 0)
        models.wings2D.Body.LW.two.three:setRot(0, rl*2*invertStrength, 0)
        models.wings2D.Body.LW.two.three.four:setRot(0, rl*3, 0)
        models.wings2D.Body.LW.two.three.four.five:setRot(0, rl*3, 0)
        models.wings2D.Body.LW.two.three.four.five.six:setRot(0, rl*3, 0)
        models.wings2D.Body.LW.two.three.four.five.six.seven:setRot(0, rl*3, 0)
        models.wings2D.Body.LW.two.three.four.five.six.seven.eight:setRot(0, rl*3, 0)

        models.wings2D.Body.RW:setRot(0, -rotation_offset+math.sin((invertTimeOffset+time)*speed)*str_*invertMultiplier*(invertStrength/2), -zrot_)
        models.wings2D.Body.RW.two2:setRot(0, rr*invertStrength, 0)
        models.wings2D.Body.RW.two2.three2:setRot(0, rr*2*invertStrength, 0)
        models.wings2D.Body.RW.two2.three2.four2:setRot(0, rr*3, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2:setRot(0, rr*3, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2:setRot(0, rr*3, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2.seven2:setRot(0, rr*3, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2.seven2.eight2:setRot(0, rr*3, 0)
    else
        local rl = idle_curve - (cape_rotation.x / 8)
        local rr = (cape_rotation.x / 8) - idle_curve

        models.wings2D.Body.LW:setRot(cape_rotation.x / 8, rotation_offset-(cape_rotation.x / 8), zrot_)
        models.wings2D.Body.LW.two:setRot(0, rl, 0)
        models.wings2D.Body.LW.two.three:setRot(0, rl*1.5, 0)
        models.wings2D.Body.LW.two.three.four:setRot(0, rl*2, 0)
        models.wings2D.Body.LW.two.three.four.five:setRot(0, rl*3.5, 0)
        models.wings2D.Body.LW.two.three.four.five.six:setRot(0, rl*5, 0)
        models.wings2D.Body.LW.two.three.four.five.six.seven:setRot(0, rl*6.5, 0)
        models.wings2D.Body.LW.two.three.four.five.six.seven.eight:setRot(0, rl*8, 0)
    
        models.wings2D.Body.RW:setRot(cape_rotation.x / 8, -rotation_offset+(cape_rotation.x / 8), -zrot_)
        models.wings2D.Body.RW.two2:setRot(0, rr, 0)
        models.wings2D.Body.RW.two2.three2:setRot(0, rr*1.5, 0)
        models.wings2D.Body.RW.two2.three2.four2:setRot(0, rr*2, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2:setRot(0, rr*3.5, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2:setRot(0, rr*5, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2.seven2:setRot(0, rr*6.5, 0)
        models.wings2D.Body.RW.two2.three2.four2.five2.six2.seven2.eight2:setRot(0, rr*8, 0)
    end
end

if host:isHost() then
    return action_wheel:newAction()
    :title("Wing settings")
    :item("minecraft:elytra")
    :onLeftClick(function()
      --store the current active page so that we can set it back as active later
      prevPage=action_wheel:getCurrentPage()
      --set this file's page as active
      action_wheel:setPage(WingWheel)
    end)
  end
