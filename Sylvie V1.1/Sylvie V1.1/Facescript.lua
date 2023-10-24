-- SCRIPT NOT (fully) BY ME - Script taken from @henem_'s face animations asset found on the Figura Discord server, and face is based on the aft forementioned asset. Tweaks have been made by me, but credit to the original creator cannot be understated. /DeadVoxels

local wait = require("runLater")

local EyeMoveLR

local defaultFaceTex
local unimpressedTex
local winkTex
local huhTex
local angyTex
local fearTex

if host:isHost() then
    defaultFaceTex = textures:read("SylvieDefaultFace", config:load("DefaultFaceTex") --[[@as string]])
    unimpressedTex = textures:read("SylvieUnimpressed", config:load("UnimpressedTex") --[[@as string]])
    winkTex = textures:read("SylvieWink", config:load("WinkTex") --[[@as string]])
    huhTex = textures:read("SylvieHuh", config:load("HuhTex") --[[@as string]])
    angyTex = textures:read("SylvieAngy", config:load("AngyTex") --[[@as string]])
    fearTex = textures:read("SylvieFear", config:load("FearTex") --[[@as string]])
end

animations.Sylvie.default:play()

local function stopFaceAnims()
    animations.Sylvie.anger:stop()
    animations.Sylvie.default:stop()
    animations.Sylvie.fear:stop()
    animations.Sylvie.rock:stop()
    animations.Sylvie.squint:stop()
    animations.Sylvie.wink:stop()
end

local facePage = action_wheel:newPage()

function pings.WinkSparkle()
    local winkSparkle = particles:newParticle("minecraft:end_rod", models.Sylvie.Head.Face.right_eye:partToWorldMatrix():apply(), vectors.rotateAroundAxis(-60, player:getLookDir() * 0.08 + vec(0, 0.04, 0), player:getRot().xy_))
    :setScale(0.25)
    :setColor(0.95, 0.90, 0.65)
    :lifetime(15)
    :gravity(0.25)
    :spawn()
    local SylvWink = sounds["minecraft:entity.experience_orb.pickup"]
    :pos(models.Sylvie.Head:partToWorldMatrix():apply())
    :volume(0.5)
    :pitch(1.2)
    :subtitle("Sylvie wink ;3")
    :play()
end

function pings.action1_click()
    stopFaceAnims()
    animations.Sylvie.default:play()
end

function pings.action2_click()
    stopFaceAnims()
    animations.Sylvie.wink:play()
    wait(8, pings.WinkSparkle)
end

function pings.action3_click()
    stopFaceAnims()
    animations.Sylvie.squint:play()
    local SylvUnimpressed = sounds["minecraft:entity.fox.aggro"]
    :pos(models.Sylvie.Head:partToWorldMatrix():apply())
    :volume(0.5)
    :pitch(0.65)
    :subtitle("Sylvie is *not* impressed.")
    :play()
end

function pings.action4_click()
    stopFaceAnims()
    animations.Sylvie.rock:play()
    local SylvHuh = sounds["minecraft:entity.fox.sniff"]
    :pos(models.Sylvie.Head:partToWorldMatrix():apply())
    :volume(0.5)
    :pitch(1.2)
    :subtitle("Sylvie is confused")
    :play()
end

function pings.action5_click()
    stopFaceAnims()
    animations.Sylvie.fear:play()
    local SylvAaa = sounds["minecraft:entity.fox.ambient"]
    :pos(models.Sylvie.Head:partToWorldMatrix():apply())
    :volume(0.5)
    :pitch(0.65)
    :subtitle("Sylvie is scared ónò'")
    :play()
end

function pings.action6_click()
    stopFaceAnims()
    animations.Sylvie.anger:play()
    local SylvAngy = sounds["minecraft:entity.fox.aggro"]
    :pos(models.Sylvie.Head:partToWorldMatrix():apply())
    :volume(1.5)
    :pitch(0.85)
    :subtitle("O boi Sylvie be angy ònó")
    :stop()
end

if host:isHost() then
    local action1 = facePage:newAction()
    :title("Default")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action1_click)
    :texture(defaultFaceTex, 7, 0, 128, 128, 0.2)

    local action2 = facePage:newAction()
    :title("Wink")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action2_click)
    :texture(winkTex, 0, 0, 128, 128, 0.2)

    local action3 = facePage:newAction()
    :title("Unimpressed")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action3_click)
    :texture(unimpressedTex, 0, 0, 128, 128, 0.2)

    local action4 = facePage:newAction()
    :title("?")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action4_click)
    :texture(huhTex, 0, 0, 128, 128, 0.2)

    local action5 = facePage:newAction()
    :title("Fear")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action5_click)
    :texture(fearTex, 0, 0, 128, 128, 0.2)

    local action6 = facePage:newAction()
    :title("Angy")
    :hoverColor(0.85, 0.25, 0.75)
    :onLeftClick(pings.action6_click)
    :texture(angyTex, 0, 0, 128, 128, 0.2)
end

function events.render(delta)
    EyeMoveLR = ((player:getRot(delta).y - player:getBodyYaw(delta) + 180) % 360 - 180)/100

    models.Sylvie.Head.Face.left_pupil.left_pupil:setPos(math.clamp(EyeMoveLR + 0.25, -0.1, 1))

    models.Sylvie.Head.Face.right_pupil.right_pupil:setPos(math.clamp(EyeMoveLR - 0.25, -1, 0.1))
end

-- Stuff for layered action menus

local prevPage
if host:isHost() then
    -- This Action just sets the stored page as active
    facePage:newAction()
      :title('Back')
      :item("minecraft:barrier")
      :onLeftClick(function() 
        action_wheel:setPage("HomePage") 
      end)

    return action_wheel:newAction()
      :title("Face control")
      :texture(defaultFaceTex, 0, 0, 128, 128, 0.25)
      :onLeftClick(function()
        --store the current active page so that we can set it back as active later
        prevPage=action_wheel:getCurrentPage()
        --set this file's page as active
        action_wheel:setPage(facePage)
      end)
end