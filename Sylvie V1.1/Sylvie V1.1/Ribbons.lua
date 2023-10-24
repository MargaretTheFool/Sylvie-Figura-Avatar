local SwingingPhysics = require("swinging_physics1")
local RibPhys = SwingingPhysics.swingOnHead
local BowRibSwingPhys = require("swinging_physics2")
local BowRibPhys = BowRibSwingPhys.swingOnHead

local Ribbon1 = {
  models.Sylvie.Head.Ribbon1_1, 
  models.Sylvie.Head.Ribbon1_1.Ribbon1_2, 
  models.Sylvie.Head.Ribbon1_1.Ribbon1_2.Ribbon1_3, 
  models.Sylvie.Head.Ribbon1_1.Ribbon1_2.Ribbon1_3.Ribbon1_4, 
  models.Sylvie.Head.Ribbon1_1.Ribbon1_2.Ribbon1_3.Ribbon1_4.Ribbon1_5
}
local Ribbon2 = {
  models.Sylvie.Head.Ribbon2_1, 
  models.Sylvie.Head.Ribbon2_1.Ribbon2_2, 
  models.Sylvie.Head.Ribbon2_1.Ribbon2_2.Ribbon2_3, 
  models.Sylvie.Head.Ribbon2_1.Ribbon2_2.Ribbon2_3.Ribbon2_4, 
  models.Sylvie.Head.Ribbon2_1.Ribbon2_2.Ribbon2_3.Ribbon2_4.Ribbon2_5
}
local Ribbon3 = {
  models.Sylvie.Head.Bow.BowRibbon1,
  models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2,
  models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2.BowRibbon3,
  models.Sylvie.Head.Bow.BowRibbon1.BowRibbon2.BowRibbon3.BowRibbon4
}
local wHatString = {
  models.Sylvie.Head.wHat.string1,
  models.Sylvie.Head.wHat.string1.string2,
  models.Sylvie.Head.wHat.string1.string2.charm,
}
local ribbonSegmentNum = {1,2,3,4,5}
local speed = 0.05
local strength = 5
local segOffset = -20

  -- Ribbon 1 swing/physics
  local RibbonPhys1 = RibPhys(Ribbon1[1], 180, {-35,50,-50,50,-50,50})
  local RibbonPhys2 = RibPhys(Ribbon1[2], 180, {-35,50,-50,50,-50,50}, Ribbon1[1], 0.5)
  local RibbonPhys3 = RibPhys(Ribbon1[3], 180, {-35,50,-50,50,-50,50}, Ribbon1[1], 1)
  local RibbonPhys4 = RibPhys(Ribbon1[4], 180, {-35,50,-50,50,-50,50}, Ribbon1[1], 2)
  local RibbonPhys5 = RibPhys(Ribbon1[5], 180, {-35,50,-50,50,-50,50}, Ribbon1[1], 3)

  --Ribbon 2 swing/physics
  local RibbonPhys6 = RibPhys(Ribbon2[1], 180, {-35,50,-50,50,-50,50})
  local RibbonPhys7 = RibPhys(Ribbon2[2], 180, {-35,50,-50,50,-50,50}, Ribbon2[1], 0.5)
  local RibbonPhys8 = RibPhys(Ribbon2[3], 180, {-35,50,-50,50,-50,50}, Ribbon2[1], 1)
  local RibbonPhys9 = RibPhys(Ribbon2[4], 180, {-25,50,-50,50,-50,50}, Ribbon2[1], 2)
  local RibbonPhys10 = RibPhys(Ribbon2[5], 180, {-15,50,-50,50,-50,50}, Ribbon2[1], 3)

  -- Bow ribbon swing/physics
  local BowRibPhys1 = BowRibPhys(Ribbon3[1], 50, {-12, 90, -90, 90, -90, 0.3})
  local BowRibPhys2 = BowRibPhys(Ribbon3[2], 50, {-12, 90, -90, 90, -90, 0.3}, Ribbon3[1], 1)
  local BowRibPhys3 = BowRibPhys(Ribbon3[3], 50, {-12, 90, -90, 90, -90, 0.3}, Ribbon3[1], 2)
  local BowRibPhys4 = BowRibPhys(Ribbon3[4], 50, {-12, 90, -90, 90, -90, 0.3}, Ribbon3[1], 3)

  -- Witch hat string physics (Best place to put that was here with the bow ribbon stuff since they use the same swing physics script)
  local wHatStringPhys1 = BowRibPhys(wHatString[1], 180)
  local wHatStringPhys2 = BowRibPhys(wHatString[2], 180, nil, wHatString[1], 1)
  local wHatStringPhys3 = BowRibPhys(wHatString[3], 180, nil, wHatString[1], 2)

function events.render(delta)
  for i, ribbonsway1 in ipairs (Ribbon1) do
    local sway = math.sin((world.getTime()+delta+(segOffset*ribbonSegmentNum[i])+0)*speed)*strength
    ribbonsway1:setOffsetRot(vec(sway*0.5,sway*0.75, 0))
  end
  for i, ribbonsway2 in ipairs (Ribbon2) do
    local sway = math.sin((world.getTime()+delta+(segOffset*ribbonSegmentNum[i])+15)*speed)*strength
    ribbonsway2:setOffsetRot(vec(sway*0.5, sway*0.75, 0))
  end
end

--function events.SKULL_RENDER(delta, block, item, entity, mode)
--  if mode == "BLOCK" then
--    RibbonPhys1:setEnabled(false)
--    RibbonPhys2:setEnabled(false)
--    RibbonPhys3:setEnabled(false)
--    RibbonPhys4:setEnabled(false)
--    RibbonPhys5:setEnabled(false)
--    RibbonPhys6:setEnabled(false)
--    RibbonPhys7:setEnabled(false)
--    RibbonPhys8:setEnabled(false)
--    RibbonPhys9:setEnabled(false)
--    RibbonPhys10:setEnabled(false)
--  end
--end

local toggle = {}

function toggle:func(tog)
    tog = not tog
    RibbonPhys1:setEnabled(tog)
    RibbonPhys2:setEnabled(tog)
    RibbonPhys3:setEnabled(tog)
    RibbonPhys4:setEnabled(tog)
    RibbonPhys5:setEnabled(tog)
    RibbonPhys6:setEnabled(tog)
    RibbonPhys7:setEnabled(tog)
    RibbonPhys8:setEnabled(tog)
    RibbonPhys9:setEnabled(tog)
    RibbonPhys10:setEnabled(tog)
end

return toggle