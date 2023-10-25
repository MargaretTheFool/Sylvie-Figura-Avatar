local BlahajIco
local SkirtIco
local ShortsIco
local pSocksIco
local ribbonsIco

local skirtTog
local shortsTog
local pSocksTog
local BlahajTog
local wHatTog

local accessoriesOn = sounds["minecraft:item.armor.equip_leather"]
  :volume(0.5)
  :subtitle("Sylvie equips an accessory")

local accessoriesOff = sounds["minecraft:item.armor.equip_leather"]
  :volume(0.5)
  :pitch(0.75)
  :subtitle("Sylvie unequips an accessory")

if host:isHost() then
  BlahajIco = textures:read("Blahaj", config:load("BlahajIco") --[[@as string]])
  SkirtIco = textures:read("SkirtIco", config:load("SkirtIco") --[[@as string]])
  ShortsIco = textures:read("ShortsIco", config:load("ShortsIco") --[[@as string]])
  pSocksIco = textures:read("pSocksIco", config:load("pSocksIco") --[[@as string]])
  ribbonsIco = textures:read("ribbonsIco", config:load("RibbonsIco") --[[@as string]])

  skirtTog = config:load("skirtToggle")
  if config:load("skirtToggle") == nil then
    skirtTog = true
  end
  shortsTog = config:load("shortsToggle")
  if config:load("shortsToggle") == nil then
    shortsTog = false
  end
  pSocksTog = config:load("pSocksToggle")
  if config:load("pSocksToggle") == nil then
    pSocksTog = true
  end
  BlahajTog = config:load("BlahajTog")
  if config:load("BlahajTog") == nil then
    BlahajTog = true
  end
  RibbonTog = config:load("RibbonTog")
  if config:load("RibbonTog") == nil then
    RibbonTog = true
  end
  wHatTog = config:load("wHatTog")
  if config:load("wHatTog") == nil then
    wHatTog = true
  end
end

function pings.SettingsSync(skirt, shorts, pSocks, blahaj, ribbons)
  skirtTog = skirt
  shortsTog = shorts
  pSocksTog = pSocks
  BlahajTog = blahaj
  RibbonTog = ribbons
end

local ShortsModel = {
  models.Sylvie.Body.ShortsHipBit,
  models.Sylvie.LeftLeg.left_thigh.leftShortThigh,
  models.Sylvie.RightLeg.right_thigh.rightShortThigh
}

local pSocksModel = {
  models.Sylvie.LeftLeg.left_thigh.leftProgSockThigh,
  models.Sylvie.RightLeg.right_thigh.rightProgSockThigh,
  models.Sylvie.LeftLeg.left_thigh.left_knee.leftProgSockKnee,
  models.Sylvie.RightLeg.right_thigh.right_knee.rightProgSockKnee,
  models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle.leftProgSockAnkle,
  models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle.rightProgSockAnkle,
  models.Sylvie.LeftLeg.left_thigh.left_knee.left_ankle.left_foot.leftProgSockFoot,
  models.Sylvie.RightLeg.right_thigh.right_knee.right_ankle.right_foot.rightProgSockFoot
}

function events.ENTITY_INIT()
  if host:isHost() then
    pings.SettingsSync(skirtTog, shortsTog, pSocksTog, BlahajTog, RibbonTog)
    WheelReset()
  end
  models.Sylvie.Body.Skirt:setVisible(skirtTog)

  for i, parts in ipairs(ShortsModel) do
  parts:setVisible(shortsTog)
  end
  
  for i, parts in ipairs(pSocksModel) do
    pSocksModel[i]:setVisible(pSocksTog)
  end
  
  models.Sylvie.Body.blahaj:setVisible(BlahajTog)

  models.Sylvie.Head.Ribbon1_1:setVisible(RibbonTog)
  models.Sylvie.Head.Ribbon2_1:setVisible(RibbonTog)

  models.Sylvie.Head.wHat:setVisible(wHatTog)
  if wHatTog then 
    models.Sylvie.Head.leftEar.LeftEarPart:setOffsetRot(69, -60, -80)
    models.Sylvie.Head.rightEar.RightEarPart:setOffsetRot(69, 60, 80)  
    models.Sylvie.Head.Bow:setPos(1.5, 2.2, 1.2)
  else
    models.Sylvie.Head.leftEar.LeftEarPart:setOffsetRot()
    models.Sylvie.Head.rightEar.RightEarPart:setOffsetRot()  
    models.Sylvie.Head.Bow:setPos()
  end
end

function Skirt(tog)
  config:save("skirtToggle", tog)
  pings.Skirt(tog)
end
function pings.Skirt(tog)
  models.Sylvie.Body.Skirt:setVisible(tog)
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

function Shorts(tog)
  config:save("shortsToggle", tog)
  pings.Shorts(tog)
  
end

function pings.Shorts(tog)
  for i, parts in ipairs(ShortsModel) do
    ShortsModel[i]:setVisible(tog)
  end
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

function Psocks(tog)
  config:save("pSocksToggle", tog)
  pings.Psocks(tog)
end

function pings.Psocks(tog)
  for i, parts in ipairs(pSocksModel) do
    pSocksModel[i]:setVisible(tog)
  end
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

function Blahaj(tog)
  config:save("BlahajTog", tog)
  pings.Blahaj(tog)
end

function pings.Blahaj(tog)
  models.Sylvie.Body.blahaj:setVisible(tog)
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

function Ribbons(tog)
  config:save("RibbonTog", tog)
  pings.Ribbons(tog)
  local toggle = require("Ribbons")
  local toggleFunc = toggle.func
  toggleFunc(tog)
end

function pings.Ribbons(tog)
  models.Sylvie.Head.Ribbon1_1:setVisible(tog)
  models.Sylvie.Head.Ribbon2_1:setVisible(tog)
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

function WitchHat(tog)
  config:save("wHatTog", tog)
  pings.witchHat(tog)
end

function pings.witchHat(tog)
  models.Sylvie.Head.wHat:setVisible(tog)
  if tog then 
      models.Sylvie.Head.leftEar.LeftEarPart:setOffsetRot(69, -60, -80)
      models.Sylvie.Head.rightEar.RightEarPart:setOffsetRot(69, 60, 80)  
      models.Sylvie.Head.Bow:setPos(1.5, 2.2, 1.2)
  else
      models.Sylvie.Head.leftEar.LeftEarPart:setOffsetRot()
      models.Sylvie.Head.rightEar.RightEarPart:setOffsetRot()  
      models.Sylvie.Head.Bow:setPos()
  end
  if tog then accessoriesOn:pos(player:getPos()):play() accessoriesOff:stop() else accessoriesOff:pos(player:getPos()):play() accessoriesOn:stop() end
end

local togglables
local skirt
local shorts
local progSocks
local blahaj --wehh can't use å :<
local ribbons
local wHat

if host:isHost() then
  togglables = action_wheel:newPage()
    skirt = togglables:newAction()
      :title("Skirt")
      :texture(SkirtIco, 0, 0, 64, 64, 0.5)
      :onLeftClick(function() 
        skirtTog = not skirtTog
        Skirt(skirtTog)
        WheelReset()
      end)
    shorts = togglables:newAction()
      :title("Shorts")
      :texture(ShortsIco, 0, 0, 64, 64, 0.5)
      :onLeftClick(function()
        shortsTog = not shortsTog
        Shorts(shortsTog)
        WheelReset()
      end)
    progSocks = togglables:newAction()
      :title("Programming socks")
      :texture(pSocksIco, 0, 0, 64, 64, 0.5)
      :onLeftClick(function()
        pSocksTog = not pSocksTog
        Psocks(pSocksTog)
        WheelReset()
      end)
    blahaj = togglables:newAction()
      :title("Blåhaj :blahaj:")
      :texture(BlahajIco, 0, 0, nil, nil, 0.45)
      :onLeftClick(function()
        BlahajTog = not BlahajTog
        Blahaj(BlahajTog)
        WheelReset()
        if BlahajTog then
          blahaj:title("Blåhaj :blahaj:")
        else
          blahaj:title("Blåhaj (Noooo why did you you get rid of themmm, they were just vibinnnn ;-;)")
        end
      end)
    ribbons = togglables:newAction()
      :title("Ribbons")
      :texture(ribbonsIco, 0, 0, nil, nil, 0.25)
      :onLeftClick(function()
      RibbonTog = not RibbonTog
      Ribbons(RibbonTog)
      WheelReset()
      end)
    wHat = togglables:newAction()
      :title("Witch hat")
      :onLeftClick(function()
        wHatTog = not wHatTog
        WitchHat(wHatTog)
        WheelReset()
      end)
    -- This Action just sets the stored page as active
    togglables:newAction()
      :title('Back')
      :item("minecraft:barrier")
      :onLeftClick(function() 
      action_wheel:setPage("Accessories") 
    end)

    function WheelReset()
        if skirtTog then 
            skirt:color(0.85, 0.25, 0.75)
            skirt:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            skirt:color(0,0,0)
            skirt:hoverColor(0.4,0.2,0.3)
        end
        if shortsTog then 
            shorts:color(0.85, 0.25, 0.75)
            shorts:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            shorts:color(0,0,0)
            shorts:hoverColor(0.4,0.2,0.3)
        end
        if pSocksTog then 
            progSocks:color(0.85, 0.25, 0.75)
            progSocks:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            progSocks:color(0,0,0)
            progSocks:hoverColor(0.4,0.2,0.3)
        end
        if BlahajTog then 
            blahaj:color(0.85, 0.25, 0.75)
            blahaj:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            blahaj:color(0,0,0)
            blahaj:hoverColor(0.4,0.2,0.3)
        end
        if RibbonTog then 
            ribbons:color(0.85, 0.25, 0.75)
            ribbons:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            ribbons:color(0,0,0)
            ribbons:hoverColor(0.4,0.2,0.3)
        end
        if wHatTog then 
            wHat:color(0.85, 0.25, 0.75)
            wHat:hoverColor(vec(0.85, 0.25, 0.75) + vec(0.15, 0.25, 0.2))
        else
            wHat:color(0,0,0)
            wHat:hoverColor(0.4,0.2,0.3)
        end
        if shortsTog and skirtTog then
            shorts:color(0.85,0.15,0.15)
            shorts:hoverColor(1, 0.2, 0.3)
            skirt:color(0.85,0.15,0.15)
            skirt:hoverColor(1, 0.2, 0.3)
        end
        end
end

function events.tick()
  if accessoriesOff:isPlaying() == false then
    accessoriesOff:stop()
  end
  if accessoriesOn:isPlaying() == false then
    accessoriesOn:stop()
  end
end

if host:isHost() then
    return action_wheel:newAction()
    :title("Togglables")
    :item("minecraft:lever")
    :onLeftClick(function()
      --store the current active page so that we can set it back as active later
      prevPage=action_wheel:getCurrentPage()
      --set this file's page as active
      action_wheel:setPage(togglables)
    end)
end