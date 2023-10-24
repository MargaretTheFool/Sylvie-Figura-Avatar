-- Auto generated script file --

--hide vanilla model
vanilla_model.PLAYER:setVisible(false)

vanilla_model.ARMOR:setVisible(false)

vanilla_model.ELYTRA:setVisible(false)

models.Sylvie.Head.Bow.BowRibbon1:offsetRot(0, 0, -2.5)
models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2:offsetRot(0, 0, 2.5)
models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2.BowRibbon3:offsetRot(0, 0, 2.5)
models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2.BowRibbon3.BowRibbon4:offsetRot(0, 0, -5)

models.Sylvie:setSecondaryRenderType("EYES")

local BackpackCheck = false

local BackpackTog = false

local AccessoriesIco
if host:isHost() then
  AccessoriesIco = textures:read("AccessoriesIco", config:load("AccessoriesIco") --[[@as string]])
end

local generalSettings = action_wheel:newPage("Accessories")

if host:isHost() then
  generalSettings:setAction(-1, require("armband"))
  generalSettings:setAction(-1, require("AccessoryToggles"))
  generalSettings:newAction()
  :title('Back')
  :item("minecraft:barrier")
  :onLeftClick(function() 
  action_wheel:setPage("HomePage") 
end)
end

local ShinySparkle
local tickCheck = world.getTime()
local hp
local _hp
function events.tick()
  if client.isModLoaded("travelersbackpack") then
    if player:getNbt()["cardinal_components"]["travelersbackpack:travelersbackpack"]["id"] == "minecraft:air" then
      BackpackCheck =  false
    else
      BackpackCheck = true
    end
    if BackpackTog ~= BackpackCheck then
      BackpackTog = BackpackCheck
    end
  end
  if BackpackCheck then
    models.Sylvie.Body.blahaj:setPos(1,7,0.5)
    models.Sylvie.Body.blahaj:setRot(0,90,0)
    models.Sylvie.Body.blahaj.head2:setRot(-10,-25,-5)
    models.Sylvie.Body.blahaj.tail:setRot(6,7,0)
    models.Sylvie.Body.blahaj.arms.larm:setRot(0,20,70)
  else
    models.Sylvie.Body.blahaj:setPos(0,0,0)
    models.Sylvie.Body.blahaj:setRot(90,-12.5,-47.5)
    models.Sylvie.Body.blahaj.head2:setRot(-10, -5, 0)
    models.Sylvie.Body.blahaj.tail:setRot(0,7.5,0)
    models.Sylvie.Body.blahaj.arms.larm:setRot(3.01405, 37.56829, -0.66133)
  end
  if player:getPose() == "CROUCHING" then
    models:setPos(0, 2, 0)
    models.Sylvie.Body:setPos(0, 1, -1)
    models.Sylvie.Body.blahaj:setPos(models.Sylvie.Body.blahaj:getPos() + vec(0, -3, 0))
  else
    models:setPos()
    models.Sylvie.Body:setPos(0, 0, 0)
  end
  hp = player:getHealth()
  if _hp == nil then _hp = hp end
  if hp < _hp then
  local hurtSound = sounds["minecraft:entity.fox.hurt"]
    :volume(1)
    :setPitch(1)
    :subtitle("Sylvie hurt")
    :setPos(player:getPos())
    :play()
    _hp = hp
  end
end

if host:isHost() then
  return action_wheel:newAction()
  :title("Clothing/accessories")
  :texture(AccessoriesIco, 0, 0, nil, nil, 1.5)
  :onLeftClick(function()
    --store the current active page so that we can set it back as active later
    prevPage=action_wheel:getCurrentPage()
    --set this file's page as active
    action_wheel:setPage(generalSettings)
  end)
end